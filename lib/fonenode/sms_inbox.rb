module Fonenode
  class SmsInbox < SmsList

    def initialize(client)
      super(client)
      @path = "sms/inbox"
      @box_type = Sms::INBOUND
    end
  end
end