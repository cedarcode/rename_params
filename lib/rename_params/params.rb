module RenameParams
  class Params

    attr_reader :params
    delegate :[], to: :params

    def initialize(params = {})
      @params = params
    end

    def convert(key, converter, namespace = [])
      klass = converter_class(converter)

      if klass && has_key?(key, namespace)
        new_value = klass.new(converter).convert(get(key, namespace))
        set(key, new_value)
      end
    end

    def rename(key, new_key, namespace = [])
      set(new_key, delete(key, namespace), namespace) if has_key?(key, namespace)
    end

    private

    def set(key, value, namespace = [])
      namespaced(namespace)[key] = value
    end

    def get(key, namespace = [])
      namespaced(namespace)[key]
    end

    def has_key?(key, namespace = [])
      namespaced = namespaced(namespace)
      namespaced.present? && namespaced.has_key?(key)
    end

    def delete(key, namespace = [])
      namespaced(namespace).delete(key)
    end

    def namespaced(namespace = [])
      params = @params
      namespace.each { |ns| params = params.present? ? params[ns] : nil }
      params
    end

    def converter_class(converter)
      if converter.is_a?(Hash)
        HashConverter
      elsif converter.is_a?(Proc)
        ProcConverter
      end
    end
  end
end