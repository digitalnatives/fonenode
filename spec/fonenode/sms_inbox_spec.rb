require 'spec_helper'

describe Fonenode::SmsInbox do
  let(:single_sms_response) {
    {
        id: "525e3fb3b218980d35000002",
        from: "2348181019102",
        to: "234803841727",
        text: "Should I still expect you today?",
        date: "2013-10-16T07:26:43.209Z"
    }
  }

  let(:sms_list_response) {
    {
        count: 1,
        offset: 0,
        total: 1,
        data: [
            {
                id: "525e3fb3b218980d35000002",
                from: "234803841727",
                to: "2348181019102",
                text: "I will be around soon",
                date: "2013-10-16T07:26:43.209Z"
            }
        ]}

  }

  before :all do
    configure_fonenode
    @client = Fonenode::Client.new
  end

  it 'should return sms with id' do
    WebMock.reset!
    stub_request(:get, stub_base_url+ "sms/inbox/525e3fb3b218980d35000002").
        to_return(body: MultiJson.dump(single_sms_response), status: 200)
    sms = @client.inbox.get_sms("525e3fb3b218980d35000002")
    expect(sms).not_to be_nil
    expect(sms.id).to eq "525e3fb3b218980d35000002"
    expect(sms.from).to eq "2348181019102"
    expect(sms.to).to eq "234803841727"
    expect(sms.text).to eq "Should I still expect you today?"
    expect(sms.date).to eq DateTime.new(2013, 10, 16, 7, 26, 43.209, "+00:00")
  end

  it 'should fill list' do
    WebMock.reset!
    stub_request(:get, stub_base_url+ "sms/inbox?limit=20&offset=0").
        to_return(body: MultiJson.dump(sms_list_response), status: 200)
    @client.inbox.get_list
    expect(@client.inbox.list.size).to eq 1
    expect(@client.inbox.list[0].id).to eq "525e3fb3b218980d35000002"
    expect(@client.inbox.list[0].from).to eq "234803841727"
    expect(@client.inbox.list[0].to).to eq "2348181019102"
    expect(@client.inbox.list[0].text).to eq "I will be around soon"
    expect(@client.inbox.list[0].date).to eq DateTime.new(2013, 10, 16, 7, 26, 43.209, "+00:00")
  end
end