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
  $check_file         = "${inventory_basedir}/cluster_${cluster_name}_success"

  # we subscribte to TWO sources:
  #     - changed inventory files
  #     - a check file execute, which only fires if the check file is NOT
  #       present.
  # this way we make sure that we continue running ansible until the cluster
  # creation was successful.

  exec { "run check for ${cluster_name}":
    command => '/usr/bin/true',
    unless  => "/usr/bin/test -f '${check_file}'"
  }

  # we use su and not runas because the output is not captured otherwise
  # (see http://is.gd/V3A3tz)
  exec { "install cluster ${cluster_name}":
    command     => "su ansible -c \"ansible-playbook -i '${inventory_file}' playbooks/byo/config.yml\"",
    cwd         => $playbook_basedir,
    path        => [ '/bin', '/usr/bin', '/usr/local/bin', ],
    refreshonly => true,
    subscribe   => [ Invfile[$cluster_name], Exec["run check for ${cluster_name}"], ],
  } ~>

  exec { "create ${check_file}":
    command     => "echo \"cluster ${cluster_name} successfully created at \$(date)\" > '${check_file}'",
    path        => [ '/usr/bin', '/bin', ],
    refreshonly => true,
  }

}
