module RenameParams
  module Macros
    module Rename
      extend ActiveSupport::Concern

      module ClassMethods
        def rename(*args)
          current_param = args.shift
          options = build_options(*args)

          before_filter options[:filters] do
            new_params = RenameParams::Params.new(params, self)
            new_params.convert(current_param, options[:convert], options[:namespace])
            new_params.rename(current_param, options[:to], options[:namespace])
            new_params.move(options[:to], options[:move_to], options[:namespace]) if options[:move_to]
          end
        end

        private

        def build_options(args = {})
          {
            to: args[:to],
            convert: args[:convert],
            move_to: move_to_options(args),
            namespace: namespace_options(args),
            filters: filter_options(args)
          }
        end

        def namespace_options(args = {})
          args[:namespace] = [] if args[:namespace] == :root
          args[:namespace].is_a?(Array) ? args[:namespace] : [args[:namespace]].compact
        end

        def move_to_options(args = {})
          return unless args[:move_to]
          args[:move_to] = [] if args[:move_to] == :root
          args[:move_to].is_a?(Array) ? args[:move_to] : [args[:move_to]].compact
        end

        def filter_options(args = {})
          {
            only: args.delete(:only),
            except: args.delete(:except)
          }.reject { |_, v| v.nil? }
        end
      end
    end
  end
end
