module BinarySolo
  module Components
    class Nginx
      attr_accessor :redirects

      def initialize(config, homebase)
        nginx_config = config[:nginx] || {}

        ssl = BinarySolo::Ssl.new

        @redirects = (nginx_config[:redirects] || []).collect do |r|
          r.merge!({
            ssl_path:   ssl.path_for_domain(r[:from]),
            ssl_domain: ssl.path_for_domain(r[:from], false)
          })
        end
        @homebase  = homebase
      end

      def enabled?
        redirects?        
      end

      def redirects?
        redirects.present?
      end

      def self.name
        :nginx
      end

      private

    end
  end
end