require_relative 'dns/domain'
require_relative 'dns/domain_record'

module BinarySolo
  class DnsSetup

    attr_reader :config, :domains

    def initialize(config, homebase)
      @logger = BinarySolo.logger

      @config = config[:dns]
      @homebase = homebase

      @domains = @config[:tld].collect { |(name, records)| Domain.new(name: name, records: records) }
      add_records_from_homebase!
    end

    def valid?
      true
    end

    def save
      return nil unless valid?
      
      ensure_domains! && ensure_records! ? self : nil
    end

    def add_records_from_homebase!
      # needed for homebase itself
      public_hosts = @homebase.config.inject([]) do |a, (k, v)|
        v.is_a?(Hash) && v[:public_host] ? a << v[:public_host] : a
      end.each do |domain| 
        url = Domainatrix.parse(domain)
        next if url.subdomain.blank?

        domain_name = "#{url.domain}.#{url.public_suffix}"
        domain = @domains.find { |d| d.name == domain_name }

        next if domain.nil? || domain.records.find { |d| d.type == 'A' && d.name == url.subdomain }
        domain.records << DomainRecord.new(type: 'A', name: url.subdomain , data: 'homebase')
      end
    end

    def registered_domains
      @registered_domains ||= @homebase.provider.
        raw_domains(include_records: true).
        collect { |rd| Domain.new(rd) }
    end

    def ensure_domains!
      @domains.each do |domain|
        destination = domain.find_record('A', '@').try(:data)
        destination = @homebase.current_ip if destination.nil? || destination == 'homebase'
        registered_domain = registered_domains.find { |d| d.name == domain.name }

        if registered_domain.blank?
          @logger.debug "#{domain.name} missing - setting to #{destination}"
          @homebase.provider.domain_create(domain.name, destination)
        else
          registered_record = registered_domain.find_record('A', '@')
          if registered_record.blank?
            @logger.debug "A @ for #{domain.name} missing - setting to #{destination}"
            @homebase.provider.domain_record_create(registered_domain, {name: '@', record_type: 'A', data: destination})
          elsif registered_record.data != destination
            @logger.debug "A @ for #{domain.name} outdated - points to #{registered_record.data} - setting to #{destination}"            
            @homebase.provider.domain_record_update(registered_domain, registered_record, {data: destination})
          else
            @logger.debug "#{domain.name} uptodate"
          end
        end
      end
    end


    def ensure_records!
      @registered_domains = nil

      domains.each do |domain|
        registered_domain = registered_domains.find { |d| d.name == domain.name }

        next if domain.records.blank? || registered_domain.blank?

        domain.records.each do |record|
          next if record.type == 'A' && record.name == '@'

          data = record.meta? ? @homebase.current_ip : record.data

          registered_record = registered_domain.find_record(record.type, record.name)

          if registered_record.nil?
            @logger.debug "#{domain.name} #{record.type} #{record.name} with #{data} is misssing"
            @homebase.provider.domain_record_create(registered_domain, {name: record.name, record_type: record.type, data: data})
          elsif registered_record.data != data
            @logger.debug "#{domain.name} #{record.type} #{record.name} with #{data} is outdated"
            @homebase.provider.domain_record_update(registered_domain, registered_record, {data: data})
          else
            @logger.debug "#{domain.name} #{record.type} #{record.name} with #{data} is uptodate"
          end
        end
      end
    end

  end
end