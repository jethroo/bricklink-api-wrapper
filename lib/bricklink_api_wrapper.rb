# frozen_string_literal: true

require 'bricklink/api'
require 'bricklink_api_wrapper/order'
require 'bricklink_api_wrapper/user_inventory'
require 'json'

module Net
  class HTTPGenericRequest
    # oauth_body_hash causes BL to not recognize the signature correctly
    def oauth_body_hash_required?
      false
    end
  end
end

module BricklinkApiWrapper
end
