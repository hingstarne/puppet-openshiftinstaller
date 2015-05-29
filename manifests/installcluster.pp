#
#
# = Resource: openshiftinstaller::installcluster
#
# Installs a cluster with the preinstalled ansbile playbook and a cluster
# name.
#
#
define openshiftinstaller::installcluster (
  $cluster_name = $title,
) {

  $inventory_basedir  = $::openshiftinstaller::inventory_basedir
  $playbook_basedir   = $::openshiftinstaller::playbook_basedir

  $inventory_file     = "${inventory_basedir}/cluster_${cluster_name}"

  # we will run only on changes to the cluster definition files. saves some
  # time, might prevent errors and keeps the change log tidy.
  # we use su and not runas because the output is not captured otherwise
  # (see http://is.gd/V3A3tz)
  exec { "install cluster ${cluster_name}":
    command     => "su ansible -c \"ansible-playbook -i '${inventory_file}' playbooks/byo/config.yml\"",
    cwd         => $playbook_basedir,
    path        => [ '/bin', '/usr/bin', '/usr/local/bin', ],
    refreshonly => true,
    subscribe   => Invfile[$cluster_name],
  }

}
