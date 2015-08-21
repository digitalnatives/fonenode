module Fonenode
  class Sms < ApiComponent
    TEMP = "tmp"
    OUTBOUND = "outbound"
    INBOUND = "inbound"
    DRAFT = "draft"
    SENT = "sent"
    attr_reader :id, :from, :to, :message, :date, :type, :status


    class << self
      def init_from_list(options={})
        raise "Can't create SMS from API without id!" if options[:id].blank?
        raise "Can't create SMS from API without sent date!" if options[:date].blank?
        raise "SMS type has to be INBOUND or OUTBOUND" if options[:type] != INBOUND && options[:type] != OUTBOUND
        message = Sms.new(options)
        date = options[:date].is_a?(DateTime) ? options[:date] : DateTime.parse(options[:date])
        message.instance_variable_set(:@id, options[:id])
        message.instance_variable_set(:@date, date)
        message.instance_variable_set(:@type, options[:type])
        message.instance_variable_set(:@status, SENT)
        message
      end

    end

    def initialize(options={})
      super()
      @from, @to, @message = options[:from], options[:to], options[:message]
      @type = TEMP
      @status = DRAFT
    end

    def send(client)
      raise "Can't send because this message is already sent" if @type != TEMP || @id.present? || @date.present? || is_sent?
      raise "Can't send because to phone number not provided" if @to.blank?
      raise "Can't send because from phone number not provided" if @from.blank?
      resp = client.post("sms", params)
      resp_body = parse_response(resp)
      if (resp.status == 201)
        @id = resp_body[:id]
        @date = Time.now
        @status = SENT
        return true
      end

      return false
    end

    def is_sent?
      @status == SENT
    end

    private
    def params
      MultiJson.dump({to: @to, from: @from, message: @message})
    end

  end
end