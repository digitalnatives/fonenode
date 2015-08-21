require 'spec_helper'

describe Fonenode::Sms do
  context "structural tests: " do
    let(:valid_temp_message) { Fonenode::Sms.new(:from => "12345", :to => "6789", :message => "Hello from spec!", :id => "not_valid", :sent_at => Time.now) }

    it "should not has an id" do
      expect(valid_temp_message.id).to be_nil
    end
    it "should not has a sent date" do
      expect(valid_temp_message.sent_at).to be_nil
    end

    it "has from phone number" do
      expect(valid_temp_message.from).to eq "12345"
    end

    it "has to phonen umber" do
      expect(valid_temp_message.to).to eq "6789"
    end

    it "has type" do
      expect(valid_temp_message.type).to eq Fonenode::Sms::TEMP
    end
  end

  context "api communication: " do
    before :each do
      configure_fonenode
      @client = Fonenode::Client.new
      @temp_id = "525e3fb3b218980d35000002"
      WebMock.reset!
      stub_request(:post, stub_base_url+ "sms").
          to_return(body: MultiJson.dump(id: @temp_id), status: 201)
    end

    it "should send if type TEMP" do
      sms = Fonenode::Sms.new(to: 1234, from: 4567, message: "Hello sms")
      expect(sms.send(@client)).to eq true
      expect(sms.is_sent?).to eq true
      expect(sms.id).to eq @temp_id
      expect { sms.send(@client) }.to raise_error("Can't send because this message is already sent")
    end

    it "should not send if has id" do
      sms = Fonenode::Sms.init_from_list(id: "12345", to: 1234, from: 4567, message: "Hello sms", sent_at: Time.now, type: Fonenode::Sms::OUTBOUND)
      expect { sms.send(@client) }.to raise_error("Can't send because this message is already sent")
    end


    it "should not send if to or from not provided" do
      sms = Fonenode::Sms.new(from: 4567, message: "Hello sms")
      expect { sms.send(@client) }.to raise_error("Can't send because to phone number not provided")
      sms = Fonenode::Sms.new(to: 4567, message: "Hello sms")
      expect { sms.send(@client) }.to raise_error("Can't send because from phone number not provided")
    end

    it "should not save if response has error or status code not 201" do
      WebMock.reset!
      stub_request(:post, stub_base_url+ "sms").
          to_return(body: "{}", status: 403)
      sms = Fonenode::Sms.new(to: 1234, from: 4567, message: "Hello sms")
      expect(sms.send(@client)).to eq false
      expect(sms.id).to be_blank
    end

    it "should fill errors array from response" do
      WebMock.reset!
      stub_request(:post, stub_base_url+ "sms").
          to_return(body: MultiJson.dump(error: "Missing id parameter."), status: 400)
      sms = Fonenode::Sms.new(to: 1234, from: 4567, message: "Hello sms")
      expect(sms.send(@client)).to eq false
      expect(sms.errors.size).to eq 1
      expect(sms.errors[0]).to eq "Missing id parameter."
    end
  end

end

