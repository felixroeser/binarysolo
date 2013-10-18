require 'bundler'
Bundler.setup
require 'colorize'
require 'rspec'
require 'rspec/given'

require_relative '../lib/binary_solo'
require_relative '../lib/binary_solo/cli'

RSpec.configure do |config|

  config.color_enabled = true
  config.formatter     = 'documentation'

  # See http://stackoverflow.com/questions/15430551/suppress-console-output-during-rspec-tests
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do 
    # Redirect stderr and stdout
    $stderr = File.new(File.join(File.dirname(__FILE__), 'dev_null.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'dev_null.txt'), 'w')
  end
  config.after(:all) do 
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

require_relative 'factories'

def test_config
  {
    provider: 'digital_ocean',
    digital_ocean: {
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
      ssh_key: '~/.ssh/randomkey',
      fwd: {
        enabled: true,
        public_host: 'fwd.example.com'
      },
      jekyll: {
        enabled: true,
        sites: [
          {
            name: 'example_blog', 
            public_host: 'blog.example.com',
            template_repo: 'https://github.com/example/up.git',
            template_branch: 'gh-pages'
          },
          {name: 'random_blog',  public_host: 'blog.random.com'}
        ]
      },
      stringer: {
        enabled: true,
        public_host: 'feeds.example.com'
      }
    }
  }.with_indifferent_access
end