# oscluster::invfile -- create inventory file for a cluster

define oscluster::invfile {

  $cluster_name = $name

  $masters = unique(query_nodes("role=\"openshift-master\" and
                         clustername=\"${cluster_name}\"", fqdn))
  $nodes = unique(query_nodes("role~\"openshift-*\" and
                         clustername=\"${cluster_name}\"", fqdn))

  file { '/etc/ansible/inventory':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }
  file { "/etc/ansible/inventory/${cluster_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('oscluster/inv_head.erb',
                        'oscluster/inv_masters.erb',
                        'oscluster/inv_nodes.erb')
  }
}
