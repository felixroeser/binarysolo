require 'spec_helper'

describe BinarySolo::Components::Fwd do

  Given(:port) { 2000 }
  Given(:homebase) { double :homebase}
  Given(:fwd) { BinarySolo::Components::Fwd.new(config, homebase) }

  context 'with fwd enabled and a public host configured' do
    Given(:config) { test_config }

    Then { fwd.enabled? == true }
    Then { fwd.public_host == config[:homebase][:fwd][:public_host] }

    describe '#up' do
      pending
    end

  end

  context 'with fwd disabled' do
    Given(:config) { test_config.deep_merge(homebase: {fwd: {enabled: false}}) }
    Then { fwd.enabled? == false }
    Then { fwd.up(port) == nil }
  end

  context 'with a blank public_host' do
    Given(:config) { test_config.deep_merge(homebase: {fwd: {public_host: nil}}) }
    Then { fwd.enabled? == false }
    Then { fwd.up(port) == nil }
  end

end
