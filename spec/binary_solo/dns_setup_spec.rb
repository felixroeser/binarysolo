require 'spec_helper'

describe BinarySolo::Provider do

  Given(:config) { test_config }
  Given(:homebase) { double :homebase, config: config[:homebase] }
  Given(:klass) { BinarySolo::DnsSetup }

  Given(:dns_setup) { klass.new(config, homebase)}

  describe '#initialize' do
    Then { dns_setup.config == config[:dns] }
    Then { dns_setup.config.present? == true }
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

  describe '#save' do
    before do
      dns_setup.should_receive(:ensure_domains!).and_return(foo_result)
    end

    context 'var steps passed' do
      before do
        dns_setup.should_receive(:ensure_records!).and_return(foo_result)
      end

      Given(:foo_result) { true }
      Then { dns_setup.save == dns_setup }
    end

    context 'ensure_domains fails' do
      before do
        dns_setup.should_not_receive(:ensure_records!)
      end

      Given(:foo_result) { false }
      Then { dns_setup.save == nil }
    end

  end

end