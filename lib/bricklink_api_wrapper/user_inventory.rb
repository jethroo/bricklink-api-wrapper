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

      payload = Bricklink::Api.new.put(
        "#{BASE_PATH}/#{inventory_id}",
        supported_params
      )
      return false unless payload.meta.code == 200

      @data = payload.data
    end

    def self.get(id)
      payload = Bricklink::Api.new.get("#{BASE_PATH}/#{id}")
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

      payload = Bricklink::Api.new.get("#{BASE_PATH}#{query_string}")
      return unless payload.meta.code == 200

      payload.data.map { |inv_data| new(inv_data) }
    end

    SUPPORTED_CREATE_PARAMS = %i[
      item
      color_id
      quantity
      unit_price
      new_or_used
      completeness
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

    def self.create(params = {})
      supported_params = params.slice(*SUPPORTED_CREATE_PARAMS)
      return false unless supported_params.any?

      payload = Bricklink::Api.new.post(
        BASE_PATH.to_s, supported_params
      )

      return false unless payload.meta.code == 201

      new(payload.data)
    end

    # API will give back an error on provided stock_room_id
    # for items with is_stock_room: true
    # they will be put in stockroom A !
    def self.bulk_create(inventories = [])
      return false unless inventories.any?

      payload = Bricklink::Api.new.post(
        BASE_PATH.to_s, inventories
      )

      payload.meta.code == 201
    end
  end
end
