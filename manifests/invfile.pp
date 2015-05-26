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
  $masters,           # array
  $nodes,             # array
) {

  validate_string($cluster_name)
  validate_array($nodes)
  validate_array($masters)

  file { '/etc/ansible/inventory':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }
  file { "/etc/ansible/inventory/openshift_cluster_${cluster_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('oscluster/inv_head.erb',
                        'oscluster/inv_masters.erb',
                        'oscluster/inv_nodes.erb')
  }
}
