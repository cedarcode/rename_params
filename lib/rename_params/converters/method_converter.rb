module RenameParams
  module Converters
    class MethodConverter
      def initialize(method, context)
        @method = method
        @context = context
      end

      def convert(value)
        @context.send(@method, value)
      end
    end
  end
end