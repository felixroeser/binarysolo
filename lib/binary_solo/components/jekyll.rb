module BinarySolo
  module Components
    class Jekyll
      attr_accessor :public_host, :ssl_path

      def initialize(config, homebase)
        jekyll_config = config[:jekyll] || {}

        @enabled     = jekyll_config[:enabled]
        @public_host = jekyll_config[:public_host]
        @ssl_path    = BinarySolo::Ssl.new.path_for_domain(@public_host)
        @homebase    = homebase
      end

      def enabled?
        @enabled && @public_host.present?
      end

      def ssl_enabled?
        enabled? && @ssl_path.present?
      end

      def self.name
        :jekyll
      end

      private

    end
  end
end