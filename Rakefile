require 'rubygems'
require 'bundler/setup'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
  task test: :spec
rescue LoadError
end