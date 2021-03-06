require 'spec_helper'

describe 'compliance_markup::test' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'when using the enforcement backend' do

      # This is limited to EL7 since that's all we have profiles for
        if ['7'].include?(facts[:os][:release][:major])
          profiles = [ 'disa', 'nist']
          profiles.each do |profile|
            order = ([ profile ] + (profiles - [ profile ])).to_s
            context "when order = #{order}" do
              let(:facts) { facts }
              let(:hieradata){ "#{profile}_spec" }

              it "should return #{profile}" do
                is_expected.to(create_notify('compliance_markup::test::testvariable').with_message("compliance_markup::test::testvariable = #{profile}"))
              end
            end
          end
          profiles = [ 'disa', 'nist']
          profiles.each do |profile|
            order = ([ profile ] + (profiles - [ profile ])).to_s
            context "when order = #{order} and data file is vendored v2" do
              let(:facts) { facts }
              let(:hieradata){ "#{profile}_spec" }

              it "should return #{profile}" do
                is_expected.to(create_notify('compliance_markup::test::v2variable').with_message("compliance_markup::test::v2variable = #{profile}"))
              end
            end
          end
        end

        profiles = [ 'disa', 'nist']
        profiles.each do |profile|
          order = ([ profile ] + (profiles - [ profile ])).to_s
          context "when order = #{order} and data file is vendored" do
            let(:facts) { facts }
            let(:hieradata){ "#{profile}_spec" }

            it "should return #{profile}" do
              is_expected.to(create_notify('compliance_markup::test::vendoredvariable').with_message("compliance_markup::test::vendoredvariable = #{profile}"))
            end
          end
        end
      end
    end
  end
end
