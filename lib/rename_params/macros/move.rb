module RenameParams
  module Macros
    class Move < Base
      class << self

        def def_move(klass, *args)
          move_param = args.shift
          options = build_options(*args)

          klass.before_filter(options[:filters]) do |controller|
            params = RenameParams::Params.new(controller.params, controller)
            params.move(move_param, options[:to], options[:namespace]) if options[:to]
          end
        end

        private

        def build_options(args = {})
          {
            to: move_to_options(:to, args),
            namespace: namespace_options(args),
            filters: filter_options(args)
          }
        end
      end
    end
  end
end
