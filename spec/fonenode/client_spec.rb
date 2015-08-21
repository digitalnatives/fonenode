require 'spec_helper'

describe Fonenode::Client do
  before :each do
    WebMock.reset!

  end
  #TODO
  # - attach command
  # - send sms
  #   - send from default number
  # - list phonenumbers
  context "random get, post request" do

    it "should raise error if auth_id or auth_secret empty" do

      expect { @client = Fonenode::Client.new }.to raise_error(RuntimeError)
      Fonenode.configure do |c|
        c.auth_id = "user"
      end
      expect { @client = Fonenode::Client.new }.to raise_error(RuntimeError)
      Fonenode.configure do |c|
        c.auth_secret = "pass"
        c.secure_http= false
      end
      @client = Fonenode::Client.new
      stub_request(:get, stub_base_url).
          to_return(:status => 200)
      resp = @client.get("/")
      expect(resp.status).to eq 200
    end

    it "should handle post request" do
      Fonenode.configure do |c|
        c.auth_id = "user"
        c.auth_secret = "pass"
        c.secure_http = false
      end
      @client = Fonenode::Client.new
      stub_request(:post, stub_base_url).
          to_return(:status => 200)
      resp = @client.post("/")
      expect(resp.status).to eq 200
    end
  end


  context "send sms" do
    before :each do
      build_client
    end

    #raise error if from blank and default number nil

  end


  context "get sms" do
    before :each do
      build_client
    end
  end

  context "get sms inbox" do
    before :each do
      build_client
    end
  end

  context "get sms outbox" do
    before :each do
      build_client
    end
  end


  def build_client
    configure_fonenode
    @client = Fonenode::Client.new
  end
end