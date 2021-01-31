# frozen_string_literal: true

require 'oauth'
require 'yaml'

module Bricklink
  class Config
    AUTH_PARAMS = %w[consumer_key consumer_secret token token_secret].freeze

    def self.file
      YAML.load_file('config/application.yml')
    end

    AUTH_PARAMS.each do |param|
      define_singleton_method(param) do
        file[param]
      end
    end
  end

  class Api
    BASE_URL = 'https://api.bricklink.com/api/store/v1'

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
