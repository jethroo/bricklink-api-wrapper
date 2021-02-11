# frozen_string_literal: true

require 'oauth'

module Bricklink
  class Api
    BASE_URL = 'https://api.bricklink.com/api/store/v1'
    CONTENT_TYPE_HEADER = { 'Content-Type' => 'application/json' }.freeze

    class RequestError < StandardError
      attr_reader :api_response

      def initialize(message, api_response)
        super(message)
        @api_response = api_response
      end
    end

    def get(path)
      api_response = access_token.get(path)

      if api_response.code.to_i == 200
        JSON.parse(api_response.body, object_class: OpenStruct)
      else
        raise RequestError.new(
          "Expected status code 200 but got #{api_response.code}",
          api_response
        )
      end
    end

    def put(path, params)
      api_response = access_token.put(path, params.to_json, CONTENT_TYPE_HEADER)

      if api_response.code.to_i == 200
        JSON.parse(api_response.body, object_class: OpenStruct)
      else
        raise RequestError.new(
          "Expected status code 200 but got #{api_response.code}",
          api_response
        )
      end
    end

    def post(path, params)
      api_response = access_token.post(path, params.to_json, CONTENT_TYPE_HEADER)

      if api_response.code.to_i == 200
        JSON.parse(api_response.body, object_class: OpenStruct)
      else
        raise RequestError.new(
          "Expected status code 200 but got #{api_response.code}",
          api_response
        )
      end
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(
        Bricklink::Config.consumer_key,
        Bricklink::Config.consumer_secret,
        { site: BASE_URL }
      )
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(
        consumer,
        Bricklink::Config.token,
        Bricklink::Config.token_secret
      )
    end
  end
end
