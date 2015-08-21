module Fonenode
  class PhoneNumbers < ApiComponent
    attr_reader :numbers
    attr_accessor :limit
    @numbers = []

    def initialize(client)
      super()
      @client = client
      @count = 0
      @limit = 20
    end

    def my_numbers(offset=0)
      clear_numbers
      clear_errors
      resp = @client.get("numbers", {limit: @limit, offset: offset})
      resp_body = parse_response(resp)
      if @errors.size == 0
        @count = resp_body[:count]
        resp_body[:data].each do |data|
          @numbers << PhoneNumber.new(data)
        end
      end
    end

    def attach_by_number(number, sms_url)
      phone_number = find_by_number(number)
      if phone_number.present?
        if attach(phone_number.id, sms_url)
          phone_number.sms_url = sms_url
        end
      end
      phone_number
    end

    def attach(id, sms_url)
      clear_errors
      resp = @client.put("numbers/#{id}", {sms_url: sms_url})
      parse_response(resp)
      @errors.size == 0
    end

    def find_by_number(number)
      my_numbers
      counter = @count
      number_of_pages = (counter/@limit).ceil-1 #counting starts from 0
      (0..number_of_pages).each do |offset|
        my_numbers(offset)
        phone_number = get_number_from_numbers(number)
        return phone_number if phone_number.present?
      end
      return nil
    end

    def get_number_from_numbers(number)
      @numbers.select { |x| x.number == number }.first
    end

    private
    def clear_numbers
      @numbers = []
      @count = 0
    end

    def clear_errors
      @errors = []
    end
  end
end