require 'spec_helper'


describe Fonenode::PhoneNumbers do
  let(:sample_response) {
    {
        count: 2,
        offset: 0,
        data: [
            {
                id: '52ca46d9f355f257a96c412c',
                number: '23414405105',
                sms_url: 'http://google.com/sms'
            },
            {
                id: '51b7c0bdbb86e153d8db4056',
                number: '23414405577'
            }
        ]
    }
  }
  let(:sample_response2) {
    {
        count: 4,
        offset: 0,
        data: [
            {
                id: '52ca46d9f355f257a96c412c',
                number: '23414405105',
                sms_url: 'http://google.com/sms'
            },
            {
                id: '51b7c0bdbb86e153d8db4056',
                number: '23414405577'
            }
        ]
    }
  }
  let(:sample_response3) {
    {
        count: 4,
        offset: 1,
        data: [
            {
                id: '52ca46d9f355f257a96c412b',
                number: '23414405106',
                sms_url: 'http://google.com/sms'
            },
            {
                id: '51b7c0bdbb86e153d8db4059',
                number: '23414405578'
            }
        ]
    }
  }
  let(:sample_attach_response) {
    {
        id: "51b7c0bdbb86e153d8db4056"
    }
  }
  before :all do
    configure_fonenode
    @client = Fonenode::Client.new
  end

  it 'should fill numbers from api call' do
    WebMock.reset!
    stub_request(:get, stub_base_url+ "numbers?limit=20&offset=0").
        to_return(body: MultiJson.dump(sample_response), status: 200)
    @client.phone_numbers.my_numbers
    expect(@client.phone_numbers.numbers.size).to eq 2
    expect(@client.phone_numbers.numbers[0].id).to eq "52ca46d9f355f257a96c412c"
    expect(@client.phone_numbers.numbers[0].number).to eq "23414405105"
    expect(@client.phone_numbers.numbers[0].sms_url).to eq "http://google.com/sms"
    expect(@client.phone_numbers.numbers[1].id).to eq "51b7c0bdbb86e153d8db4056"
    expect(@client.phone_numbers.numbers[1].number).to eq "23414405577"
  end

  it 'should attach by number' do
    WebMock.reset!
    @client.phone_numbers.limit = 2
    stub_request(:get, stub_base_url+ "numbers?limit=2&offset=0").
        to_return(body: MultiJson.dump(sample_response2), status: 200)
    stub_request(:get, stub_base_url+ "numbers?limit=2&offset=1").
        to_return(body: MultiJson.dump(sample_response3), status: 200)
    stub_request(:put, stub_base_url+ "numbers/51b7c0bdbb86e153d8db4059").
        to_return(body: MultiJson.dump(sample_attach_response), status: 201)
    number = @client.phone_numbers.attach_by_number("23414405578", "http://google.com/n_sms")
    expect(number.sms_url).to eq "http://google.com/n_sms"
  end


  it 'should not attach invalid number' do
    WebMock.reset!
    stub_request(:get, stub_base_url+ "numbers?limit=2&offset=0").
        to_return(body: MultiJson.dump(sample_response2), status: 200)
    stub_request(:get, stub_base_url+ "numbers?limit=2&offset=1").
        to_return(body: MultiJson.dump(sample_response3), status: 200)
    stub_request(:put, stub_base_url+ "numbers/51b7c0bdbb86e153d8db4056").
        to_return(body: MultiJson.dump(sample_response), status: 201)
    expect { @client.phone_numbers.attach_by_number("1234567", "http://google.com/n_sms") }.to raise_error
  end


end
