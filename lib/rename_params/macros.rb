module RenameParams
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def rename(*args)
        current_param = args.shift
        callback_options = extract_callback_options(*args)
        options = args.shift
        before_filter "rename_param_#{current_param}".to_sym, callback_options

        define_method("rename_param_#{current_param}") do
          rename_params = Params.new(params)
          rename_params.convert(current_param, options[:convert])
          rename_params.rename(current_param, options[:to])
        end
      end

      private

      def extract_callback_options(args = {})
        {
          only: args.delete(:only),
          except: args.delete(:except)
        }.reject { |_, v| v.nil? }
      end
    end
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)