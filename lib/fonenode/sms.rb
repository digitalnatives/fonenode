module Fonenode
  class Sms < ApiComponent
    TEMP = "tmp"
    OUTBOUND = "outbound"
    INBOUND = "inbound"
    DRAFT = "draft"
    SENT = "sent"
    attr_reader :id, :from, :to, :text, :date, :type, :status, :delivery_date, :mock, :delivery


    class << self
      def init_from_list(options={})
        raise "Can't create SMS from API without id!" if options[:id].blank?
        raise "Can't create SMS from API without sent date!" if options[:date].blank?
        raise "SMS type has to be INBOUND or OUTBOUND" if options[:type] != INBOUND && options[:type] != OUTBOUND
        message = Sms.new(options)
        date = options[:date].is_a?(DateTime) ? options[:date] : DateTime.parse(options[:date])
        delivery_date = options[:delivery_date].is_a?(DateTime) ? options[:delivery_date] : DateTime.parse(options[:delivery_date]) if options[:delivery_date].present?
        message.instance_variable_set(:@id, options[:id])
        message.instance_variable_set(:@date, date)
        message.instance_variable_set(:@type, options[:type])
        message.instance_variable_set(:@status, SENT)
        message.instance_variable_set(:@delivery_date, delivery_date) if delivery_date.present?
        message.instance_variable_set(:@from, options[:from])
        message.instance_variable_set(:@to, options[:to])
        message.instance_variable_set(:@mock, options[:mock].present? ? options[:mock] : false)
        message.instance_variable_set(:@delivery, options[:delivery]) if options[:delivery]
        message
      end

    end

    def initialize(options={})
      super()
      @from, @to, @text = options[:from], options[:to], options[:text]
      @type = TEMP
      @status = DRAFT
    end

    def send(client)
      raise "Can't send because this message is already sent" if @type != TEMP || @id.present? || @date.present? || is_sent?
      raise "Can't send because to phone number not provided" if @to.blank?
      raise "Can't send because from phone number not provided" if @from.blank?
      puts "SEND PARAMETERS: #{params}"
      if Fonenode.config.mock
        resp = client.post("sms_mock", params)
      else
        resp = client.post("sms", params)
      end
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
      MultiJson.dump({to: @to, from: @from, text: @text})
    end

  end
end