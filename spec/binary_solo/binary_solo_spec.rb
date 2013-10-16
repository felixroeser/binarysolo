require 'spec_helper'

describe BinarySolo do
  before do
    BinarySolo.stub config: test_config
  end

  Then { BinarySolo.config.present? == true }
  Then { BinarySolo.config_valid? == true }

end