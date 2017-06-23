module RenameParams
  module Macros
    class Rename < Base
      class << self

        def def_rename(klass, *args)
          rename_param = args.shift
          options = build_options(*args)

          klass.before_action options[:filters] do |controller|
            params = RenameParams::Params.new(controller.params, controller)
            params.convert(rename_param, options[:convert], options[:namespace])
            params.rename(rename_param, options[:to], options[:namespace])
            params.move(options[:to], options[:move_to], options[:namespace]) if options[:move_to]
          end
        end

        private

        def build_options(args = {})
          {
            to: args[:to],
            convert: args[:convert],
            move_to: move_to_options(:move_to, args),
            namespace: namespace_options(args),
            filters: filter_options(args)
          }
        end
      end
    end
  end
end
