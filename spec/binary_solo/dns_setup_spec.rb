require 'spec_helper'

describe BinarySolo::Provider do

  Given(:homebase) { double :homebase}
  Given(:config) { test_config }
  Given(:klass) { BinarySolo::DnsSetup }

  Given(:dns_setup) { klass.new(config, homebase)}

  describe '#initialize' do
    Then { dns_setup.config == config[:dns] }
  end

  describe '#registered_domains' do
    before do
      homebase.stub_chain(:provider, :raw_domains).and_return(raw_domains_response)
    end

    context 'some domains registered' do
      Given(:raw_domains_response) { Factories.raw_domains(2) }
      When(:result) {  dns_setup.registered_domains }
      Then { result.size == 2 }
      Then { result.map(&:class).uniq == [BinarySolo::Domain] }
    end

    context 'no domains registered' do
      Given(:raw_domains_response) { [] }
      When(:result) {  dns_setup.registered_domains }
      Then { result == []}
    end

  end

end