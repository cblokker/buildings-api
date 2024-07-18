module UseCaseV1
  module Building
    class Create
      def initialize(building_id:, client_id:, address_attrs:, custom_fields:)
      end

      def call
        validate_custom_fields
        create_address!
        create_building!

        ::Result.sucess(
          status: 'success',
          building.to_api
        )
      ActiveRecord::RecordNotFound,
      StandardError => error
        ::Result.failure(error.message)
      end

      private

      attr_reader :building_id, :client_id, :address_attrs, :custom_fields,
        :building, :address, :client

      def client
        @client ||= Client.find(client_id)
      end

      def create_address!
        @address ||= Address.create!(address_attrs)
      end

      def create_building!
        @building ||= Building.create!(
          address: address,
          custom_fields: prepare_custom_fields
        )
      end

      def validate_custom_fields
      end
    end
  end
end
