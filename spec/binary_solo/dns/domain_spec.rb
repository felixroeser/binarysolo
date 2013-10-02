require 'spec_helper'

describe BinarySolo::Domain do

  Given(:homebase) { double :homebase}
  Given(:config) { test_config }
  Given(:klass) { BinarySolo::Domain }
  
  # relies on fixtures
  Given(:domain_name) { 'example.com' }
  Given(:domain_config) { config[:dns][:tld][domain_name] }
  Given(:domain) { klass.new({name: domain_name, records: domain_config}) }
  
  describe '#initialize' do

    Then { domain.name == domain_name }
    Then { domain.records.size == domain_config.size }
    Then { domain.records.map(&:class).uniq == [BinarySolo::DomainRecord] }
  end

end