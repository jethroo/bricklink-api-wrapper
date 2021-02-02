# frozen_string_literal: true

module BricklinkApiWrapper
  class UserInventory
    BASE_PATH = '/inventories'

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def self.get(id)
      net_http_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}/#{id}")
      return unless net_http_response.code.to_i == 200

      json_body = JSON.parse(net_http_response.body)

      return unless json_body['meta']['code'] == 200

      new(json_body['data'])
    end

    def self.index(params = { status: 'S' })
      param_string = URI.encode_www_form(params).empty? ? '' : "?#{URI.encode_www_form(params)}"
      net_http_response = Bricklink::Api.new.access_token.get("#{BASE_PATH}#{param_string}")
      return unless net_http_response.code.to_i == 200

      json_body = JSON.parse(net_http_response.body)

      return unless json_body['meta']['code'] == 200

      json_body['data'].map { |inv_data| new(inv_data) }
    end
  end
end
