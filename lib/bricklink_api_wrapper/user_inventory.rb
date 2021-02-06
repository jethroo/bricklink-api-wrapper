# frozen_string_literal: true

module BricklinkApiWrapper
  class UserInventory
    BASE_PATH = '/inventories'

    STATUS = {
      available: 'Y',
      stockroom_a: 'S',
      stockroom_b: 'B',
      stockroom_c: 'C',
      unavailable: 'N',
      reserved: 'R'
    }.freeze

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def self.get(id)
      net_http_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}/#{id}")
      return unless net_http_response.code.to_i == 200

      payload = JSON.parse(net_http_response.body, object_class: OpenStruct)

      return unless payload.meta.code == 200

      new(payload.data)
    end

    def self.index(params = { status: STATUS[:stockroom_a] })
      supported_params = params.slice(:item_type, :status, :category_id, :color_id)
      query_string = supported_params.empty? ? '' : "?#{URI.encode_www_form(supported_params)}"

      net_http_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}#{query_string}")
      return unless net_http_response.code.to_i == 200

      payload = JSON.parse(net_http_response.body, object_class: OpenStruct)

      return unless payload.meta.code == 200

      payload.data.map { |inv_data| new(inv_data) }
    end
  end
end
