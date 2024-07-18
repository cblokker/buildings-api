# NOTE: When adding auth, we can swap out client_id with devise / session store / jwt to get client
module Api
  module V1
    class BuildingsController < ApplicationController
      before_action :set_building, only: [:update]
      before_action :set_client, only: [:create, :update]

      # GET /api/v1/buildings?per_page={per_page}&after={last_id}
      def index
        buildings = Paginators::KeysetById.new(**building_paginate_params).call

        render json: {
          status: 'success', # Note: redundant with code 200 - encourange client to base success/failure off status codes, not strings.
          buildings: buildings.map(&:to_api) # Note: probably a big performance drop with this map - would encourage not flattening custom_fields (with the jsonb design) & go with a serializer
        }, status: :ok
      end

      # POST /api/v1/buildings
      # Note: If building logic becomes complex, we can move to use case (for now keep it simple):
      #       https://thecodest.co/blog/applying-the-use-case-pattern-with-rails/
      def create
        @building = @client.buildings.new(building_params)

        if @building.save
          render json: {
            status: 'success',
            building: @building.to_api
          }, status: :created
        else
          render json: @building.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/buildings/:id
      def update
        if @building.client == @client && @building.update(building_params) # Note: need to consider pulling out into use case, for granular error messages.
          render json: {
            status: 'success',
            building: @building.to_api
          }
        else
          render json: @building.errors, status: :unprocessable_entity
        end
      end

      private

      def set_building
        @building = Building.find(params[:id])
      end

      def set_client
        @client = Client.find(params[:client_id]) if params[:client_id]
      end

      def building_params
        params.require(:building).permit(
          custom_fields: {},
          address_attributes: [:id, :street_address, :city, :state, :zip]
        )
      end

      def building_paginate_params
        params.permit(:after_id, :per_page).compact.to_h.symbolize_keys
      end
    end
  end
end
