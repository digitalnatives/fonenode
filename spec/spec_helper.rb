require 'fonenode'
require 'byebug'
require 'webmock/rspec'
require 'vcr'


WebMock.disable_net_connect!(allow_localhost: true)

def stub_base_url
  "user:pass@#{Fonenode.endpoint_uri}/#{Fonenode.config.api_version}/"
end

def configure_fonenode
  Fonenode.configure do |c|
    c.auth_id = "user"
    c.auth_secret = "pass"
    c.secure_http = false
  end
end
