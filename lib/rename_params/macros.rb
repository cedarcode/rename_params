module RenameParams
  module Macros
    extend ActiveSupport::Concern

    class_methods do
      def rename(*args)
        current_param = args.shift
        before_action_options = extract_callback_options(*args)
        before_action "rename_param_#{current_param}".to_sym, before_action_options

        define_method("rename_param_#{current_param}") do
          Params.new(params).rename(current_param, *args)
        end
      end

      private

      def extract_callback_options(args = {})
        {
          only: args.delete(:only),
          except: args.delete(:except)
        }.compact
      end
    end
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)