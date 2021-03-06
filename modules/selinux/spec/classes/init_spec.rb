require 'spec_helper'

#TODO add modern selinux facts to simp-rspec-puppet-facts
selinux_base_facts = {
  config_mode:    "enforcing",
  config_policy:  "targeted",
  current_mode:   "enforcing",
  enabled:        true,
  enforced:       true,
  policy_version: "28"
}

describe 'selinux' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_file('/etc/selinux/config').with_content(<<-EOF.gsub(/^\s+/,'')
          # This file controls the state of SELinux on the system.
          # SELINUX= can take one of these three values:
          # enforcing - SELinux security policy is enforced.
          # permissive - SELinux prints warnings instead of enforcing.
          # disabled - SELinux is fully disabled.
          SELINUX=enforcing
          # SELINUXTYPE= type of policy in use. Possible values are:
          # targeted - Only targeted network daemons are protected.
          # strict - Full SELinux protection.
          SELINUXTYPE=targeted
          EOF
          ) }
        it { is_expected.to contain_package('checkpolicy').with(ensure: 'installed') }
        it { is_expected.to contain_package('mcstrans').with(ensure: 'installed') }

        if os_facts[:os][:release][:major].to_i >= 7
          it { is_expected.to create_service('mcstransd').with({
            enable: true,
            ensure: 'running'
          }) }
          it { is_expected.not_to contain_package('policycoreutils-restorecond') }
          it { is_expected.not_to create_service('restorecond') }
        else
          it { is_expected.to create_service('mcstrans').with({
            enable: true,
            ensure: 'running'
          }) }
          it { is_expected.to contain_package('policycoreutils').with(ensure: 'installed') }
          it { is_expected.to create_service('restorecond').with({
            enable: true,
            ensure: 'running'
          }) }
        end
      end

      context 'with ensure set to a non-boolean' do
        let(:params) {{ ensure: 'permissive' }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_file('/etc/selinux/config').with_content(<<-EOF.gsub(/^\s+/,'')
          # This file controls the state of SELinux on the system.
          # SELINUX= can take one of these three values:
          # enforcing - SELinux security policy is enforced.
          # permissive - SELinux prints warnings instead of enforcing.
          # disabled - SELinux is fully disabled.
          SELINUX=permissive
          # SELINUXTYPE= type of policy in use. Possible values are:
          # targeted - Only targeted network daemons are protected.
          # strict - Full SELinux protection.
          SELINUXTYPE=targeted
          EOF
          ) }
      end

      context 'with ensure set to false and restorecond enabled' do
        let(:params) {{
          ensure: false,
          manage_restorecond_package: true,
          manage_restorecond_service: true
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_file('/etc/selinux/config').with_content(<<-EOF.gsub(/^\s+/,'')
          # This file controls the state of SELinux on the system.
          # SELINUX= can take one of these three values:
          # enforcing - SELinux security policy is enforced.
          # permissive - SELinux prints warnings instead of enforcing.
          # disabled - SELinux is fully disabled.
          SELINUX=disabled
          # SELINUXTYPE= type of policy in use. Possible values are:
          # targeted - Only targeted network daemons are protected.
          # strict - Full SELinux protection.
          SELINUXTYPE=targeted
          EOF
          ) }
        it { is_expected.to contain_package('mcstrans').with(ensure: 'installed') }

        if os_facts[:os][:release][:major].to_i >= 7
          it { is_expected.to create_service('mcstransd').with(
            enable: true,
            ensure: 'stopped'
          ) }
          it { is_expected.to contain_package('policycoreutils-restorecond').with(ensure: 'installed') }
        else
          it { is_expected.to create_service('mcstrans').with(
            enable: true,
            ensure: 'stopped'
          ) }
          it { is_expected.to contain_package('policycoreutils').with(ensure: 'installed') }
        end
        it { is_expected.to create_service('restorecond').with(
          enable: true,
          ensure: 'stopped'
        ) }
      end

      context 'with mode set' do
        let(:params) {{ mode: 'mls' }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_file('/etc/selinux/config').with_content(<<-EOF.gsub(/^\s+/,'')
          # This file controls the state of SELinux on the system.
          # SELINUX= can take one of these three values:
          # enforcing - SELinux security policy is enforced.
          # permissive - SELinux prints warnings instead of enforcing.
          # disabled - SELinux is fully disabled.
          SELINUX=enforcing
          # SELINUXTYPE= type of policy in use. Possible values are:
          # targeted - Only targeted network daemons are protected.
          # strict - Full SELinux protection.
          SELINUXTYPE=mls
          EOF
          ) }
      end

      context 'with manage_utils_package => false' do
        let(:params) {{ manage_utils_package: false }}
        it { is_expected.to_not contain_package('checkpolicy') }
      end

      context 'notifying user of reboots' do
        context 'enabled -> enabled' do
          let(:params) {{ ensure: 'enforcing' }}
          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to create_reboot_notify('selinux') }
        end
        context 'enabled -> disabled' do
          let(:facts) do
            os_facts
          end
          let(:params) {{ ensure: 'disabled' }}
          it { is_expected.to create_reboot_notify('selinux') }
        end
        context 'enabled -> false' do
          let(:facts) do
            os_facts
          end
          let(:params) {{ ensure: false }}
          it { is_expected.to create_reboot_notify('selinux') }
        end
        context 'enabled -> permissive' do
          let(:facts) do
            os_facts
          end
          let(:params) {{ ensure: 'permissive' }}
          it { is_expected.not_to create_reboot_notify('selinux') }
        end
        context 'disabled -> disabled' do
          let(:facts) do
            os_facts = os_facts.dup
            os_facts[:selinux] = false
            os_facts
          end
          let(:params) {{ ensure: 'disabled' }}
          it { is_expected.not_to create_reboot_notify('selinux') }
        end
        context 'disabled -> enabled' do
          let(:facts) do
            os_facts = os_facts.dup
            os_facts[:selinux] = false
            os_facts
          end
          let(:params) {{ ensure: 'enforcing' }}
          it { is_expected.to create_reboot_notify('selinux') }
        end
        context 'disabled -> true' do
          let(:facts) do
            os_facts = os_facts.dup
            os_facts[:selinux] = false
            os_facts
          end
          let(:params) {{ ensure: true }}
          it { is_expected.to create_reboot_notify('selinux') }
        end
        context 'disabled -> permissive' do
          let(:facts) do
            os_facts = os_facts.dup
            os_facts[:selinux] = false
            os_facts
          end
          let(:params) {{ ensure: 'permissive' }}
          it { is_expected.to create_reboot_notify('selinux') }
        end
      end
    end
  end
end
