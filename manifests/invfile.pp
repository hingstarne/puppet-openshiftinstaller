#
# = Define openshiftinstaller::invfile
#
# == Summary
#
# Creates the inventory file for a given cluster, which is identified by
# its cluster name.
#
#
define openshiftinstaller::invfile (
  # required parameters
  $basedir,           # string
  $masters,           # array
  $nodes,             # array

  # optional parameters
  $cluster_name       = $name,
) {

  validate_string($cluster_name)
  validate_array($nodes)
  validate_array($masters)

  $registry_url = $::openshiftinstaller::registry_url

  file { "${basedir}/cluster_${cluster_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('openshiftinstaller/inventory_file.erb'),
  } ~>

  # if the cluster changed the run-until-success cycle should start over,
  # not only one run (if we don't delete the file)
  exec { "delete check file for cluster ${cluster_name}":
    command     => "rm -f '${basedir}/cluster_${cluster_name}_success'",
    path        => [ '/usr/bin', '/bin', ],
    refreshonly => true,
  }

}
