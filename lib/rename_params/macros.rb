module RenameParams
  module Macros
    extend ActiveSupport::Concern

    class_methods do
      def rename(*args)
        current_param = args.shift
        before_action "rename_param_#{current_param}".to_sym

        define_method("rename_param_#{current_param}") do
          Params.new(params).rename(current_param, *args)
        end
      end
    end
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)