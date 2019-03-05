require 'simp/rake/pupmod/helpers'
require 'puppet-strings/tasks'

Simp::Rake::Pupmod::Helpers.new(File.dirname(__FILE__))

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end
