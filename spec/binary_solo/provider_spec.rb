require 'spec_helper'

describe BinarySolo::Provider do

  Given(:klass) { BinarySolo::Provider }

  context 'for an unsupported provider' do
    Given(:provider_name) { 'not_digitalocean' }

    Then { klass.supported?(provider_name) == false }
    Then { klass.find_by_name(provider_name) == nil }
  end

  context 'for an supported provider' do
    Given(:provider_name) { 'digital_ocean' }

    Then { klass.supported?(provider_name) == true }
    Then { klass.find_by_name(provider_name) == BinarySolo::Provider::DigitalOcean }    
  end

end