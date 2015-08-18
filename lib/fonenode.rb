require 'uri'
require 'fonenode/version'
require 'fonenode/configuration'

module Fonenode
  extend SingleForwardable
  def_delegators :config, :endpoint_uri, :endpoint_uri=, :api_version, :api_version=

  class << self
    def configure
      yield config if block_given?
    end

    def config
      @config ||= Configuration.new
    end

    def reset_config
      @config = nil
    end


  end
end
