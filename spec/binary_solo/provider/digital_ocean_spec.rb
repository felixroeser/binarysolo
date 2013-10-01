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

end