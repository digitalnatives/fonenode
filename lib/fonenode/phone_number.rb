module Fonenode
  class PhoneNumber
    attr_accessor :id, :number, :sms_url

    def initialize(options={})
      @id = options[:id]
      @number = options[:number]
      @sms_url = options[:sms_url]
    end
  end
end