require 'active_support'
require 'active_support/core_ext'
require 'rename_params/params'

module RenameParams
  extend ActiveSupport::Concern

  class_methods do
    def rename(*args)
      current_param = args.shift
      before_action "rename_param_#{current_param}"

      define_method("rename_param_#{current_param}") do
        Params.new(params).rename(current_param, *args)
      end
    end
  end
end

ActionController::API.send(:include, RenameParams) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams) if defined?(ActionController::Base)