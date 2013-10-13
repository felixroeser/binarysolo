require 'spec_helper'

describe BinarySolo::Components::JekyllSite do
  Given(:homebase) { double :homebase}
  Given(:jekyll)   { BinarySolo::Components::Jekyll.new(config[:homebase], homebase) }
  Given(:sites)    { jekyll.sites }

  context 'with name and server configured' do
    Given(:config) { test_config }
    Given(:site)   { sites.first }

    Then { site.valid? == true }
  end

end