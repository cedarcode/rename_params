module RenameParams
  class Params

    delegate :[], to: :params

    def initialize(params = {})
      @params = params
    end

    def convert(key, converter)
      klass = converter_class(converter)

      if klass && @params.has_key?(key)
        @params[key] = klass.new(converter).convert(@params[key])
      end
    end

    def rename(key, new_key)
      @params[new_key] = @params.delete(key) if @params.has_key?(key)
    end

    private

    def converter_class(converter)
      if converter.is_a?(Hash)
        HashConverter
      elsif converter.is_a?(Proc)
        ProcConverter
      end
    end

    def params
      @params
    end
  end
end