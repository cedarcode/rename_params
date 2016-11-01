module RenameParams
  class Params

    delegate :[], to: :params

    def initialize(params = {})
      @params = params
    end

    def rename(key, options = {})
      to = options[:to]

      if @params.has_key?(key)
        if options[:convert]
          set_value(key, to, options[:convert])
        else
          @params[to] = @params.delete(key)
        end
      end
    end

    private

    def set_value(key, to, value_converter)
      previous_value = @params.delete(key)

      if value_converter.is_a?(Hash)
        @params[to] = value_converter.with_indifferent_access[previous_value]
      elsif value_converter.is_a?(Proc)
        @params[to] = value_converter.call(previous_value)
      end
    end

    def params
      @params
    end
  end
end