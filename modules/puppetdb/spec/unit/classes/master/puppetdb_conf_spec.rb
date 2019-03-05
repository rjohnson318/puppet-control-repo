require 'spec_helper'

describe 'puppetdb::master::puppetdb_conf', :type => :class do
  let :node do
    'puppetdb.example.com'
  end
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
            :puppetversion => Puppet.version,
            :selinux => false
        })

      end

      let(:pre_condition) { 'class { "puppetdb": }' }

      context 'when using using default values' do
        it { should contain_ini_setting('puppetdbserver_urls').with( :value => 'https://localhost:8081/' )}
      end

      context 'when using using default values' do
        let (:params) do { :legacy_terminus => true, } end
        it { should contain_ini_setting('puppetdbserver').with( :value => 'localhost' )}
        it { should contain_ini_setting('puppetdbport').with( :value => '8081' )}
      end

    end
  end
end
