module BinarySolo
  module Components
    class Fwd
      attr_accessor :public_host, :ssl_path, :ssl_domain

      def initialize(config, homebase)
        fwd_config = config[:fwd] || {}

        @enabled     = fwd_config[:enabled]
        @homebase    = homebase        
        @public_host = fwd_config[:public_host]
        @ssl_path    = BinarySolo::Ssl.new.path_for_domain(@public_host)
        @ssl_domain  = BinarySolo::Ssl.new.path_for_domain(@public_host, false)        
      end

      def enabled?
        @enabled && @public_host.present?
      end

      def ssl_enabled?
        enabled? && @ssl_path.present?
      end

      def up(port, opts={})
        return nil unless enabled?

        begin
          `#{ssh_cmd(port)}`
        rescue SignalException
          puts "quitting..." unless opts[:silent]
        end
      end

      def self.name
        :fwd
      end

      private

      def ssh_cmd(port)
        "ssh -N -R 8989:localhost:#{port} #{@homebase.master}@#{@homebase.current_ip}"
      end

    end
  end
end