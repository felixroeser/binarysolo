require 'spec_helper'

describe BinarySolo::Components::Jekyll do
  Given(:homebase) { double :homebase}
  Given(:jekyll) { BinarySolo::Components::Jekyll.new(config[:homebase], homebase) }

  context 'with jekyll enabled and a public host configured' do
    Given(:config) { test_config }

    Then { jekyll.enabled? == true }
    Then { jekyll.sites.size == 2 }
    Then { jekyll.sites.map(&:class).uniq == [BinarySolo::Components::JekyllSite] }

    context 'with an invalid site' do
      Given(:sites) { [double(:site, valid?: true), double(:site, valid?: false)] }
      before do
        jekyll.stub sites: sites
      end

      Then { jekyll.valid_sites == [sites.first] }
    end
  end

  context 'with jekyll disabled' do
    Given(:config) { test_config.deep_merge(homebase: {jekyll: {enabled: false}}) }
    Then { jekyll.enabled? == false }
    Then { jekyll.sites.present? == true }
  end

  context 'with a blank sites' do
    Given(:config) { test_config.deep_merge(homebase: {jekyll: {sites: nil}}) }
    Then { jekyll.enabled? == false }
    Then { jekyll.sites == [] }
  end

end