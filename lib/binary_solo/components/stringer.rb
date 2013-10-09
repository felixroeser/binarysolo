module BinarySolo
  module Components
    class Stringer
      attr_accessor :public_host, :ssl_path

      def initialize(config, homebase)
        stringer_config = config[:stringer] || {}

        @enabled     = stringer_config[:enabled]
        @public_host = stringer_config[:public_host]
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
        :stringer
      end

      private

    end
  end
end