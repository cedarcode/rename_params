module RenameParams
  module Converters
    class HashConverter
      def initialize(hash = {})
        @hash = hash
      end

      def convert(value)
        @hash.with_indifferent_access[value]
      end
    end
  end
end