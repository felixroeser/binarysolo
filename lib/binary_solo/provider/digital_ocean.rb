module BinarySolo
  module Provider
    class DigitalOcean
      attr_accessor :config, :client, :name

      def initialize(config)
        @name   = self.class.name
        @config = config[:digitalocean]
        @debug  = false
        @client = ::DigitalOcean::API.new @config.slice(:client_id, :api_key).merge(debug: @debug)
      end

      def find_droplet_by_name(name)
        client.droplets.list['droplets'].find { |d| d['name'] == name }
      end

      def self.name
        'digitalocean'
      end

    end
  end
end
