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

      api_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}#{query_string}")
      return unless api_response.code.to_i == 200

      payload = JSON.parse(api_response.body, object_class: OpenStruct)

      return unless payload.meta.code == 200

      payload.data.map { |order_data| new(order_data) }
    end
  end
end
