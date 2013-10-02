require 'bundler'
Bundler.setup
require 'rspec'
require 'rspec/given'

require_relative '../lib/binary_solo'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

require_relative 'factories'

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
    dns: {
      tld: {
        'example.com' => [
          {type: 'A', name: '@',     data: 'homebase'},
          {type: 'A', name: 'www',   data: 'homebase'},
          {type: 'A', name: 'feeds', data: 'homebase'},
          {type: 'MX', data: 'gmail' }

        ],
        'random.com' => [
          {type: 'A', name: '@', data: '192.168.1.2'},
          {type: 'MX', data: '192.168.1.2', priority: 10},
          {type: 'MX', data: 'homebase', priority: 20}
        ],
        'whatever.com' => nil
      }
    },
    homebase: {
      master: 'earl',
      hostname: 'homebase',
      public_host: 'example.com',
      fwd: {
        enabled: true,
        public_host: 'fwd.example.com'
      },
      stringer: {
        enabled: true,
        public_host: 'feeds.example.com'
      }
    }
  }.with_indifferent_access
end