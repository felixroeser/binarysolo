require_relative 'jekyll_site'

module BinarySolo
  module Components
    class Jekyll
      attr_accessor :sites, :public_key

      def initialize(config, homebase)
        jekyll_config = config[:jekyll] || {}

        @enabled         = jekyll_config[:enabled]
        @sites           = (jekyll_config[:sites] || []).collect { |config| JekyllSite.new(config) }
        @public_key =  "#{config[:ssh_key]}.pub"
        @homebase    = homebase
      end

      def enabled?
        @enabled && @sites.present?
      end

      def valid_sites
        sites.select { |s| s.valid? }
      end

      def for_playbook
        {}
      end

      def self.name
        :jekyll
      end

      private

    end
  end
end