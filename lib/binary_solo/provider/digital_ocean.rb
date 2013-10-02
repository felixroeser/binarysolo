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

      def raw_domains(opts={})
        response = @client.domains.list
        return [] unless response['status'] == 'OK'
        response['domains'].collect do |d| 
          {
            name: d['name'], 
            provider_id: d['id'],
            records: opts[:include_records] ? raw_records_for_domain(d['id']) : nil
          }
        end
      end

      def raw_records_for_domain(domain_id)
        response = @client.domains.list_records(domain_id)
        return [] unless response['status'] == 'OK'
        response['records'].collect do |r| 
          r.except('id', 'domain_id', 'record_type').
            merge(provider_id: r['id'], type: r['record_type']).
            with_indifferent_access
        end
      end

      def self.name
        'digitalocean'
      end

    end
  end
end
