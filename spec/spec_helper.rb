ENV['RAILS_ENV'] = 'test'
ENV['DATABASE_URL'] = 'sqlite3://localhost/tmp/rename_params_test'

require 'bundler/setup'
require 'rails'
if Rails.version.start_with?('4.0')
  require 'support/apps/rails4_0'
elsif Rails.version.start_with?('4.1')
  require 'support/apps/rails4_1'
elsif Rails.version.start_with?('4.2')
  require 'support/apps/rails4_2'
elsif Rails.version.start_with?('5.0')
  require 'support/apps/rails5_0'
end
require 'rename_params'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end