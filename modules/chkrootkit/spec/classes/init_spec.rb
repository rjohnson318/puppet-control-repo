require 'spec_helper'

describe 'chkrootkit' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'with default parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to create_class('chkrootkit') }
          it { is_expected.to create_package('chkrootkit') }
          it { is_expected.to create_cron('chkrootkit').with_command('/usr/sbin/chkrootkit -n') }
        end

        context 'with syslog => true' do
          let(:params) {{
            :syslog   => true,
            :log_dest => 'random string that is hard to validate'
          }}
          it { is_expected.to create_cron('chkrootkit').with_command('/usr/sbin/chkrootkit -n | /bin/logger -p random string that is hard to validate -t chkrootkit') }
        end

        context 'with destination set to cron' do
          let(:params) {{ :log_dest => 'cron' }}
          it { is_expected.to create_cron('chkrootkit').with_command('/usr/sbin/chkrootkit -n') }
        end

      end
    end
  end
end
