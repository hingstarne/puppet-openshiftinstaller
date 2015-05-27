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
  $cluster_name       = $name,
  $basedir,           # string
  $masters,           # array
  $nodes,             # array
) {

  validate_string($cluster_name)
  validate_array($nodes)
  validate_array($masters)

  $registry_url = $::openshiftinstaller::registry_url

  file { "${basedir}/cluster_${cluster_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('openshiftinstaller/inventory_file.erb'),
  }
}
