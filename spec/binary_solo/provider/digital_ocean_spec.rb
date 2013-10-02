require 'spec_helper'

describe BinarySolo::Provider::DigitalOcean do

  Given(:digital_ocean) { described_class.new(test_config) }

  describe '#initialize' do
    context 'with a valid config' do
      Then { digital_ocean.name == described_class.name }
      Then { digital_ocean.config == test_config[:digitalocean] }
      Then { digital_ocean.client.present? == true }
    end

  end

  describe '#find_droplet_by_name' do
    Given(:finder) { digital_ocean.find_droplet_by_name('homebase') }

    context 'with the droplet being present' do
      Given(:droplets) { [{'name' => 'a', 'name' => 'homebase'}] }
      When { digital_ocean.client.stub_chain(:droplets, :list).and_return({'droplets' => droplets}) }
      Then { finder == droplets.last}
    end

    context 'with the droplet not being present' do
      When { digital_ocean.client.stub_chain(:droplets, :list).and_return({'droplets' => []}) }
      Then { finder == nil }
    end
  end

  describe '#raw_domains' do
    before do
      digital_ocean.client.stub_chain(:domains, :list).and_return(foo_response)
    end

    context 'request successful' do

      Given(:foo_response) do 
        {'status' => 'OK', 'domains' => [{'id' => 123, 'name' => 'example.com'} ] }
      end

      Then { digital_ocean.raw_domains.size == 1 }
      Then { digital_ocean.raw_domains.first[:provider_id] == 123 }
      Then { digital_ocean.raw_domains.first[:name] == 'example.com' }

      context 'include records' do
        before do
          digital_ocean.should_receive(:raw_records_for_domain).with(123).and_return(:foo)
        end
        Then { digital_ocean.raw_domains(include_records: true).first[:records] == :foo }
      end

    end

    context 'request failed' do
      Given(:foo_response) { {'status' => 'FAILED' } }
      Then { digital_ocean.raw_domains == [] }
    end
  end

  describe '#raw_records_for_domain' do
    Given(:provider_id) { 123 }
    before do
      digital_ocean.client.stub_chain(:domains, :list_records).and_return(foo_response)
    end

    context 'request successful' do
      Given(:foo_response) do
        {
          'status' => 'OK',
          'records' => [
            {'data' => '192.168.1.1', 'domain_id' => 123, 'id' => 456, name: '@', 'record_type' => 'A'}
          ]
        }
      end

      When(:result) { digital_ocean.raw_records_for_domain(provider_id) }
      Then { result.size == 1}
      Then { result.first[:provider_id] == 456 }
      Then { result.first[:type] = 'A' }
      Then { result.first[:data] = '192.168.1.1' }
      Then { result.first[:name] == '@'}
    end

    context 'request failed' do
      Given(:foo_response) { {'status' => 'FAILED' } }
      When(:result) { digital_ocean.raw_records_for_domain(provider_id) }
      Then { result == [] }
    end

  end

end