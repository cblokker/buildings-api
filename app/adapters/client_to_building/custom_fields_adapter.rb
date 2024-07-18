module ClientToBuilding
  class CustomFieldsAdapter

    def initialize(client_custom_field_attributes)
      @client_custom_field_attributes = client_custom_field_attributes.with_indifferent_access
    end

    def call
      {
        type: 'object',
        properties: structure_properties,
        additionalProperties: false
      } # Note: Test string/symbol keys
    end

    private

    attr_reader :client_custom_field_attributes

    def structure_properties
      client_custom_field_attributes.transform_values do |value|
        apply_transform(value)
      end
    end

    def apply_transform(value)
      case value[:type]
      when 'number' then { type: 'number' }
      when 'freeform' then { type: 'string' }
      when 'enum' then { type: 'string', enum: value[:options] }
      else raise ArgumentError, "Unsupported type '#{value[:type]}' encountered"
      end
    end
  end
end
