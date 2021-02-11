# frozen_string_literal: true

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
end
