require 'spec_helper'

describe 'openshiftinstaller::invfile' do

  context 'basic check' do
    let(:facts) {{
      :operatingsystemfamily => 'Redhat',
      :test_and_dont_run     => true,
    }}
    let(:pre_condition) {"class { 'openshiftinstaller': }"}
    let(:title) {'cluster2'}
    let (:params) {{
      :basedir  => '/etc/ansible/openshift_inventory',
      :masters  => [ 'ma01.t.d', 'ma02.t.d' ],
      :nodes    => [ 'mi01.t.d', 'mi02.t.d' ],
    }}
    it { should contain_file('/etc/ansible/openshift_inventory/cluster_cluster2').
      with_content(/\[masters\]\nma01.t.d openshift_hostname=ma01.t.d\nma02.t.d openshift_hostname=ma02.t.d\n/) }
    it { should contain_file('/etc/ansible/openshift_inventory/cluster_cluster2').
      with_content(/\[nodes\]\nmi01.t.d openshift_hostname=mi01.t.d\nmi02.t.d openshift_hostname=mi02.t.d\n/) }
    it { should contain_file('/etc/ansible/openshift_inventory/cluster_cluster2').
      with_content(/# ... no additional properties set.\n/) }
  end


  context 'with variables set globally' do
    let(:facts) {{
      :operatingsystemfamily => 'Redhat',
      :test_and_dont_run     => true,
    }}
    let(:pre_condition) {"class { 'openshiftinstaller': invfile_properties => { hey => ho, lets => go } }"}
    let(:title) {'cluster2'}
    let (:params) {{
      :basedir  => '/etc/ansible/openshift_inventory',
      :masters  => [ 'ma01.t.d', 'ma02.t.d' ],
      :nodes    => [ 'mi01.t.d', 'mi02.t.d' ],
    }}
    it { should contain_file('/etc/ansible/openshift_inventory/cluster_cluster2').
      with_content(/hey="ho"\nlets="go"\n/) }
  end


  context 'with variables set globally and locally' do
    let(:facts) {{
      :operatingsystemfamily => 'Redhat',
      :test_and_dont_run     => true,
    }}
    let(:pre_condition) {"class { 'openshiftinstaller': invfile_properties => { hey => ho, lets => go } }"}
    let(:title) {'cluster2'}
    let (:params) {{
      :basedir    => '/etc/ansible/openshift_inventory',
      :masters    => [ 'ma01.t.d', 'ma02.t.d' ],
      :nodes      => [ 'mi01.t.d', 'mi02.t.d' ],
      :properties => { 'rock' => 'ho' }
    }}
    it { should contain_file('/etc/ansible/openshift_inventory/cluster_cluster2').
      with_content(/hey="ho"\nlets="go"\nrock="ho"\n/) }
  end


end