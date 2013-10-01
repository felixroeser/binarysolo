require 'bundler'
Bundler.setup
require 'rspec'
require 'rspec/given'

require_relative '../lib/binary_solo'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def test_config
  {
    provider: 'digitalocean',
    digitalocean: {
      client_id: 'random_client_id',
      api_key: 'random_api_key',
      size: '512MB',
      region: 'San Francisco 1',
      image: 'Ubuntu 12.04 x64'
    },
    homebase: {
      master: 'earl',
      hostname: 'homebase'
    }
  }.with_indifferent_access
end