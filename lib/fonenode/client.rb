module Fonenode
  class Client
    #TODO send_sms(from, to, message) from can be default
    #get sms with post request check  message with get message from inbox, to validate it
    attr_reader :inbox, :outbox, :phone_numbers

    def initialize
      @connection = faraday_connection
      @inbox = SmsInbox.new(self)
      @outbox = SmsOutbox.new(self)
      @phone_numbers = PhoneNumbers.new(self)
    end

    def send_sms(to, text, from=nil)
      raise "You have to setup defult number, or set from parameter" if from.blank? && Fonenode.default_number.blank?
      from = Fonenode.default_number if from.blank?
      sms = Sms.new({to: to, text: text, from: from})
      sms.send(self)
      sms
    end


    def get(path, params={})
      @connection.get "#{Fonenode.config.api_version}/#{path}", params
    end

    def post(path, params={})
      #@connection.post "#{Fonenode.config.api_version}/#{path}", params
      @connection.post do |req|
        req.url "#{Fonenode.config.api_version}/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params
      end

    end

    def put(path, params={})
      @connection.put do |req|
        req.url "#{Fonenode.config.api_version}/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params
      end
    end

    private
    def faraday_connection
      raise "You have to config auth id and auth secret" if Fonenode.auth_id.blank? || Fonenode.auth_secret.blank?
      Faraday.new(:url => "#{Fonenode.endpoint_url}") do |faraday|
        faraday.use Faraday::Request::Retry
        faraday.use Faraday::Request::BasicAuthentication, Fonenode.auth_id, Fonenode.auth_secret
        faraday.use Faraday::Response::Logger
        faraday.use Faraday::Adapter::NetHttp
      end
    end

  end
end