$:.push File.expand_path('../lib', __FILE__)
require 'rename_params/version'

Gem::Specification.new do |s|
  s.name        = 'rename_params'
  s.version     = RenameParams::VERSION.dup
  s.date        = '2016-10-31'
  s.summary     = 'Simple params renaming for Rails applications'
  s.description = 'Simple params renaming for Rails applications'
  s.authors     = ['Marcelo Casiraghi']
  s.email       = 'marcelo@paragon-labs.com'
  s.homepage    = 'http://rubygems.org/gems/rename_params'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split('\n')
  s.test_files    = `git ls-files -- spec/*`.split('\n')
  s.require_paths = ['lib']

  s.add_dependency 'activesupport'
  s.add_dependency 'actionpack'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'
end
