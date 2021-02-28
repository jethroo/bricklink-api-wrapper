# frozen_string_literal: true

require 'forwardable'

module BricklinkApiWrapper
  class Order
    extend Forwardable

    BASE_PATH = '/orders'

    def_delegators :@data, :order_id, :date_ordered, :date_status_changed,
                   :seller_name, :store_name, :buyer_name, :status,
                   :total_count, :unique_count, :is_filed,
                   :salesTax_collected_by_bl, :payment, :cost, :disp_cost

    alias id order_id

    def initialize(data)
      @data = data
    end

    SUPPORTED_INDEX_PARAMS = %i[
      direction
      status
      filed
    ].freeze

    def self.index(params = {})
      supported_params = params.slice(*SUPPORTED_INDEX_PARAMS)
      query_string = supported_params.empty? ? '' : "?#{URI.encode_www_form(supported_params)}"

      payload = Bricklink::Api.new.get("#{BASE_PATH}#{query_string}")

      return unless payload.meta.code == 200

      payload.data.map { |order_data| new(order_data) }
    end

    def self.get(id)
      payload = Bricklink::Api.new.get("#{BASE_PATH}/#{id}")
      return unless payload.meta.code == 200

      new(payload.data)
    end

    def items
      return @items if @items

      payload = Bricklink::Api.new.get("#{BASE_PATH}/#{id}/items")
      return unless payload.meta.code == 200

      @items = payload.data.flatten # ignore batches for now
    end
  end
end
