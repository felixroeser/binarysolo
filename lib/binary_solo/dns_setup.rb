require_relative 'dns/domain'
require_relative 'dns/domain_record'

module BinarySolo
  class DnsSetup

    attr_reader :config, :domains

    def initialize(config, homebase)
      @config = config[:dns]
      @homebase = homebase

      @domains = @config[:tld].collect { |(name, records)| Domain.new(name: name, records: records) }
    end

    def registered_domains
      @registered_domains ||= @homebase.provider.
        raw_domains(include_records: true).
        collect { |rd| Domain.new(rd) }
    end

    def valid?
      true
    end

    def save
      return nil unless valid?
      
      self
    end

  end
end