module RenameParams
  module Macros
    class Base
      class << self

        def namespace_options(args = {})
          args[:namespace] = [] if args[:namespace] == :root
          args[:namespace].is_a?(Array) ? args[:namespace] : [args[:namespace]].compact
        end

        def move_to_options(key, args = {})
          return unless args[key]
          args[key] = [] if args[key] == :root
          args[key].is_a?(Array) ? args[key] : [args[key]]
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
