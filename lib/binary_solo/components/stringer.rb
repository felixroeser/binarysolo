module BinarySolo
  module Components
    class Stringer
      attr_accessor :public_host, :ssl_path, :ssl_domain, :password, :interval, :postgres_user_password

      def initialize(config, homebase)
        stringer_config = config[:stringer] || {}

        @enabled     = stringer_config[:enabled]
        @public_host = stringer_config[:public_host]
        @password    = stringer_config[:password]
        @interval    = stringer_config[:interval]
        @postgres_user_password = stringer_config[:postgres_user_password]

        @ssl_path    = BinarySolo::Ssl.new.path_for_domain(@public_host)
        @ssl_domain  = BinarySolo::Ssl.new.path_for_domain(@public_host, false)
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