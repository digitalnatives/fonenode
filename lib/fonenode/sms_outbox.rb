module Fonenode
  class SmsOutbox < SmsList


    def initialize(client)
      super(client)
      @path = "sms/outbox"
      @box_type = Sms::OUTBOUND
    end
  end
end