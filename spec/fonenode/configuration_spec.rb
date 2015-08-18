require 'spec_helper'

describe 'configuration' do
  before :each do
    Fonenode.reset_config
  end
  it 'has endpoint uri' do
    expect(Fonenode.endpoint_uri).to eq Fonenode::Configuration::DEFAULT_ENDPOINT_URI
    Fonenode.endpoint_uri = "google.com"
    expect(Fonenode.endpoint_uri).to eq "google.com"
    Fonenode.configure do |config|
      config.endpoint_uri = "yahoo.com"
    end
    expect(Fonenode.endpoint_uri).to eq "yahoo.com"
  end

  it 'has valid enpoint url' do
    Fonenode.endpoint_uri = "google.com"
    expect(Fonenode.config.is_url_valid?).to be true
    Fonenode.endpoint_uri = "invalid##host.com"
    expect(Fonenode.config.is_url_valid?).to be false
  end

  it 'has api version' do
    expect(Fonenode.api_version).to eq Fonenode::Configuration::DEFAULT_API_VERSION
    Fonenode.api_version = "v2"
    expect(Fonenode.api_version).to eq "v2"
    Fonenode.configure do |config|
      config.api_version= "v3"
    end
    expect(Fonenode.api_version).to eq "v3"
  end

  it 'has auth id' do
    Fonenode.configure do |config|
      config.auth_id= "auth_id2"
    end
    expect(Fonenode.config.auth_id).to eq "auth_id2"
  end

  it 'has auth secret' do
    Fonenode.configure do |config|
      config.auth_secret= "auth_secret2"
    end
    expect(Fonenode.config.auth_secret).to eq "auth_secret2"
  end

  it 'has https' do
    expect(Fonenode.config.secure_http).to eq true
  end
  it 'has http' do
    Fonenode.configure do |config|
      config.secure_http= false
    end
    expect(Fonenode.config.secure_http).to eq false
  end
end