module Fonenode
  class SmsList < ApiComponent
    attr_accessor :limit
    attr_reader :list
    @list = []
    @path = ""
    @box_type = ""

    def initialize(client)
      super()
      @client = client
      @count = 0
      @limit = 20
    end

    def get_sms(id)
      resp = @client.get("#{@path}/#{id}")
      resp_body = parse_response(resp)
      if @errors.size == 0
        resp_body[:type] = @box_type
        return Sms.init_from_list(resp_body)
      end
      return nil
    end

    def get_list(offset=0)
      clear_list
      clear_errors
      resp = @client.get(@path, {limit: @limit, offset: offset})
      resp_body = parse_response(resp)
      if @errors.size == 0
        @count = resp_body[:count]
        resp_body[:data].each do |data|
          data[:type] = @box_type
          @list << Sms.init_from_list(data)
        end
      end
    end

    private
    def clear_list
      @count = 0
      @list = []
    end

    def clear_errors
      @errors = []
    end
  end
end