require 'spec_helper'

describe 'openshiftinstaller' do


  context "puppetDB check fact negative" do
    let(:params) {{
        :registry_url => "my_url",
    }}
    let(:facts) {{
      :operatingsystemfamily => 'Redhat',
    }}
    it { should contain_class('ansible') }
    it { should contain_class('ansible::playbooks') }
  end

  context "puppetDB check fact positive" do
    let(:params) {{
        :registry_url => "my_url",
    }}
    let(:facts){{
      :operatingsystemfamily => 'Redhat',
      :osi_puppetdb_running  => 'yes',
    }}
    it { should contain_class('ansible') }
    it { should contain_class('ansible::playbooks').\
      that_comes_before('Class[openshiftinstaller]') }
  end


end