#
# = Class: openshiftinstaller::params
#
# == Summary
#
# Parameters file for ::openshiftinstaller. Currently only for the test data ... .
#
#
class openshiftinstaller::params {

  $test_masters = {
    'ma01.t.d' => {
      'openshift_cluster_name' => 'cluster0',
    },
    'ma02.t.d' => {
      'openshift_cluster_name' => 'cluster0',
    },
    'ma11.t.d' => {
      'openshift_cluster_name' => 'cluster1',
    },
    'ma12.t.d' => {
      'openshift_cluster_name' => 'cluster1',
    },
  }
  $test_minions = {
    'mi01.t.d' => {
      'openshift_cluster_name' => 'cluster0',
    },
    'mi02.t.d' => {
      'openshift_cluster_name' => 'cluster0',
    },
    'mi11.t.d' => {
      'openshift_cluster_name' => 'cluster1',
    },
    'mi12.t.d' => {
      'openshift_cluster_name' => 'cluster1',
    },
  }

}
