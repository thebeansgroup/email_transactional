module EmailTransactional
  class Template
    def initialize(html)
      @html = html
      @erb = ERB.new(html)
    end

    def populate(params = {})
      @erb.result(bindings_from(params))
    end

    private

    def bindings_from(params)
      bindings = binding
      normalized_params(params).each do |key, value|
        bindings.local_variable_set(key.to_sym, value)
      end
      bindings
    end

    def normalized_params(params)
      normalized = {}
      params.each do |key, value|
        if value.is_a?(Array)
          normalized.merge!(normalize_array(key, value))
        else
          normalized[key] = value
        end
      end
      normalized
    end

    def normalize_array(key, array)
      result = {}
      array.each_with_index do |element, index|
        if element.is_a?(Hash)
          result.merge!(normalize_hash(key, element, index))
        else
          result["#{key}_#{index + 1}"] = element
        end
      end
      result
    end

    def normalize_hash(root, hash, index)
      params = {}
      hash.each do |key, value|
        params["#{root}_#{key}_#{index + 1}"] = value
      end
      params
    end
  end
end
