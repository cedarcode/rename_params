Gem::Specification.new do |s|
  s.name        = 'rename_params'
  s.version     = '1.0.0'
  s.date        = '2016-10-31'
  s.summary     = 'Simple params renaming for Rails applications'
  s.description = 'Simple params renaming for Rails applications'
  s.authors     = ['Marcelo Casiraghi']
  s.email       = 'marcelo@paragon-labs.com'
  s.files       = ['lib/rename_params.rb']
  s.homepage    = 'http://rubygems.org/gems/rename_params'
  s.license     = 'MIT'

  s.add_dependency 'activesupport'
  s.add_dependency 'actionpack'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'byebug'

  s.add_development_dependency 'rails'
  s.add_development_dependency 'sqlite3'

end
