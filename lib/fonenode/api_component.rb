module Fonenode
  class ApiComponent
    attr_reader :errors

    def initialize
      @errors = []
    end

    def parse_response(response)
      resp_body = {}
      begin
        resp_body = MultiJson.load(response.body)
        resp_body= resp_body.deep_symbolize_keys
        if resp_body[:error].present?
          @errors << resp_body[:error]
        end
      rescue MultiJson::ParseError => exception
        @errors << exception.data
      end
      resp_body
    end


  end
end