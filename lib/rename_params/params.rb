module RenameParams
  class Params

    attr_reader :params
    delegate :[], to: :params

    def initialize(params = {}, controller = nil)
      @params = params
      @controller = controller
    end

    def convert(key, converter, namespace = [])
      converter = converter_class(converter)

      if converter && has_key?(key, namespace)
        new_value = converter.convert(get(key, namespace))
        set(key, new_value, namespace)
      end
    end

    def rename(key, new_key, namespace = [])
      set(new_key, delete(key, namespace), namespace) if has_key?(key, namespace)
    end

    def move(key, target = [], namespace = [])
      set(key, delete(key, namespace), target) if has_key?(key, namespace)
    end

    private

    def set(key, value, namespace = [])
      create_namespace(namespace)
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

    def create_namespace(namespace)
      params = @params
      namespace.each do |ns|
        params[ns] ||= {}
        params = params[ns]
      end
    end

    def converter_class(converter)
      if converter.is_a?(Hash)
        RenameParams::Converters::HashConverter.new(converter)
      elsif converter.is_a?(Proc)
        RenameParams::Converters::ProcConverter.new(converter)
      elsif converter.is_a?(Symbol)
        RenameParams::Converters::MethodConverter.new(converter, @controller)
      end
    end
  end
end