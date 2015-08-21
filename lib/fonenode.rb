require 'uri'
require 'faraday'
require 'multi_json'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'
require 'fonenode/version'
require 'fonenode/configuration'
require 'fonenode/api_component'
require 'fonenode/sms'
require 'fonenode/sms_list'
require 'fonenode/sms_inbox'
require 'fonenode/sms_outbox'
require 'fonenode/phone_number'
require 'fonenode/phone_numbers'
require 'fonenode/client'

module Fonenode
  extend SingleForwardable
  def_delegators :config, :endpoint_uri, :endpoint_uri=, :api_version, :api_version=,
                 :endpoint_url, :auth_id, :auth_secret, :default_number

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
