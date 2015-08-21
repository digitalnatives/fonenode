module Fonenode
  class Configuration
    DEFAULT_ENDPOINT_URI = "api.fonenode.com"
    DEFAULT_API_VERSION = "v1"

    attr_accessor :endpoint_uri, :api_version, :secure_http, :auth_id, :auth_secret, :secure_http, :default_number

    def initialize
      @endpoint_uri = DEFAULT_ENDPOINT_URI
      @api_version = DEFAULT_API_VERSION
      @secure_http = true
    end

    def endpoint_url
      "#{protocol_param}://#{@endpoint_uri}"
    end

    def is_url_valid?
      !!URI.parse(endpoint_url)
    rescue URI::InvalidURIError
      false
    end

    private
    def protocol_param
      @secure_http ? "https" : "http"
    end
  end
end