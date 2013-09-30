module BinarySolo
  class Dns
    include ERB::Util
    attr_accessor :config

    def initialize(config)
      @config_homebase = config[:homebase]
      @config_dns      = config[:dns]

      @do_client = ::DigitalOcean::API.new client_id: config[:digitalocean][:client_id], api_key: config[:digitalocean][:api_key], debug: false 
    end

    def save
      ensure_tld
      reset_cache!
      ensure_subd

      self
    end

    private

    def ensure_tld
      puts "* dns.ensure_tld".colorize(:blue)

      @config_dns[:tld].each_pair do |tld_name, records_setup|
        records_setup ||= []

        unless all_record = records_setup.find { |r| r[:type] == 'A' && r[:name] == '@' }
          puts "...no A @ record to be setup for #{tld_name}".colorize(:yellow)
          next
        end

        destination_ip_address = get_destination_ip_address(all_record[:data])

        domain = registered_tlds.find { |d| d['name'] == tld_name}

        if domain.blank?          
          puts "...registering #{tld_name} to #{destination_ip_address}".colorize(:yellow)
          register_tld(tld_name, destination_ip_address)
          puts "...done".colorize(:green)
        else
          current_ip_address = current_all_ip_for(domain)
          if current_ip_address.nil? || current_ip_address != destination_ip_address
            puts "...updating A @ record for #{tld_name}".colorize(:yellow)
            ensure_record_for(domain, {record_type: 'A', name: '@', data: destination_ip_address})
            puts "...done".colorize(:green)
          else
            puts "...#{tld_name} already points to #{destination_ip_address}".colorize(:green)
          end
        end
      end
    end

    def ensure_subd
      puts "* dns.ensure_subdomains".colorize(:blue)

      # needed for homebase itself
      subdomains = @config_homebase.inject([@config_homebase[:dns_record]]) do |a, (k, v)|
        v.is_a?(Hash) && v[:dns_record] ? a << v[:dns_record] : a
      end.compact.collect do |domain| 
        url = Domainatrix.parse(domain)
        next if url.subdomain.blank?
        {tld: "#{url.domain}.#{url.public_suffix}", type: "A", name: url.subdomain , data: 'homebase'}
      end.compact

      # add the rest
      subdomains = @config_dns[:tld].inject(subdomains) do |a, (tld_name, records_setup)|
        (records_setup || []).each { |r| a << r.merge({tld: tld_name}).symbolize_keys if r['type'] != 'A' || r['name'] != '@' }
        a
      end.uniq.group_by { |r| r[:tld] }

      subdomains.each_pair do |tld_name, records|
        if domain = registered_tlds.find { |d| d['name'] == tld_name}
          ensure_record_for(domain, records)
        else
          puts "...#{tld_name} is not registered!".colorize(:red)
        end
      end
    end

    # some helpers ; to be refactored

    def get_destination_ip_address(data=nil)
      (data || 'homebase').tap { |s| s.replace(homebase_ip) if s == 'homebase' }
    end

    def reset_cache!
      @registered_tlds = nil
    end

    def registered_tld_names
      registered_tlds.collect { |d| d['name'] }
    end

    def registered_tlds
      @registered_tlds ||= @do_client.domains.list['domains']
    end

    def register_tld(tld_name, ip_address)
      @do_client.domains.create name: tld_name, ip_address: ip_address
    end

    def ensure_record_for(domain, records=[])
      tld_name = domain['name']
      records = [records] unless records.is_a?(Array)

      current_records = @do_client.domains.list_records(domain['id'])['records']

      records.each do |record|
        current_record = current_records.find do |r| 
          r['domain_id'] == domain['id'] && r['record_type'] == record[:type] && r['name'] == record[:name]
        end

        destination = get_destination_ip_address(record[:data])

        if current_record.blank?
          puts "...new record needed for #{record[:name]}.#{tld_name} #{record[:type]} -> #{destination}".colorize(:yellow)
          @do_client.domains.create_record(domain['id'], {name: record[:name], data: record[:data], record_type: record[:type]} )
          puts "...done".colorize(:green)
        elsif record[:data] != current_record['data']
          puts "...updating #{record[:name]}.#{tld_name}".colorize(:yellow)
          @do_client.domains.edit_record(domain['id'], current_record['id'], {name: record[:name], data: record[:data], record_type: record[:type]} )
          puts "...done".colorize(:green)
        else
          puts "...#{record[:name]}.#{tld_name} is already registered".colorize(:green)
        end
      end
    end

    def current_all_ip_for(domain_or_tld)
      (current_all_record_for(domain_or_tld) || {})['data']
    end

    def current_all_record_for(domain_or_tld)
      domain = domain_or_tld.is_a?(String) ? registered_tlds.find { |d| d['name'] == domain_or_tld} : domain_or_tld
      return nil unless domain

      @do_client.domains.list_records(domain['id'])['records'].find { |r| r['record_type'] == 'A' && r['name'] == '@'}
    end

    def homebase_ip
      homebase_droplet['ip_address'] rescue nil
    end

    def homebase_droplet
      @homebase_droplet ||= @do_client.droplets.list['droplets'].find { |d| d['name'] == 'homebase' }
    end

  end
end
