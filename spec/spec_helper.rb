ENV['RAILS_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite3://localhost/tmp/rename_params_test'

require 'rename_params'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Support::Macros

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end