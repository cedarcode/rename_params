require 'spec_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  def build_params(params = {})
    params.each_with_object(ActionController::Parameters.new) do |(key, value), memo|
      if value.is_a?(Hash)
        memo[key] = build_params(value)
      else
        memo[key] = value
      end
    end
  end
end
