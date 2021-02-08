# frozen_string_literal: true

require 'forwardable'

module BricklinkApiWrapper
  class UserInventory
    extend Forwardable

    BASE_PATH = '/inventories'

    STATUS = {
      available: 'Y',
      stockroom_a: 'S',
      stockroom_b: 'B',
      stockroom_c: 'C',
      unavailable: 'N',
      reserved: 'R'
    }.freeze

    def_delegators :@data, :inventory_id, :item, :color_id,
                   :color_name, :quantity, :new_or_used, :unit_price,
                   :bind_id, :description, :remarks, :bulk,
                   :is_retain, :is_stock_room, :stock_room_id,
                   :date_created, :my_cost, :sale_rate, :tier_quantity1,
                   :tier_price1, :tier_quantity2, :tier_price2,
                   :tier_price3, :tier_quantity3, :my_weight

    def initialize(data)
      @data = data
    end

    SUPPORTED_UPDATE_PARAMS = %i[
      quantity
      unit_price
      description
      remarks
      bulk
      is_retain
      is_stock_room
      stock_room_id
      my_cost
      sale_rate
      tier_quantity1
      tier_price1
      tier_quantity2
      tier_price2
      tier_quantity3
      tier_price3
    ].freeze

    def update(params = {})
      supported_params = params.slice(*SUPPORTED_UPDATE_PARAMS)
      return false unless supported_params.any?

      api_response = Bricklink::Api.new.access_token.put(
        "#{BASE_PATH}/#{inventory_id}", supported_params.to_json,
        { 'Content-Type' => 'application/json' }
      )

      return false unless api_response.code.to_i == 200

      payload = JSON.parse(api_response.body, object_class: OpenStruct)

      return false unless payload.meta.code == 200

      @data = payload.data
    end

    def self.get(id)
      api_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}/#{id}")
      return unless api_response.code.to_i == 200

      payload = JSON.parse(api_response.body, object_class: OpenStruct)

      return unless payload.meta.code == 200

      new(payload.data)
    end

    SUPPORTED_INDEX_PARAMS = %i[
      item_type
      status
      category_id
      color_id
    ].freeze

    def self.index(params = { status: STATUS[:stockroom_a] })
      supported_params = params.slice(*SUPPORTED_INDEX_PARAMS)
      query_string = supported_params.empty? ? '' : "?#{URI.encode_www_form(supported_params)}"

      api_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}#{query_string}")
      return unless api_response.code.to_i == 200

      payload = JSON.parse(api_response.body, object_class: OpenStruct)

      return unless payload.meta.code == 200

      payload.data.map { |inv_data| new(inv_data) }
    end
  end
end
