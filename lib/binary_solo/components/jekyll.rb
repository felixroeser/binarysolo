module BinarySolo
  module Components
    class Jekyll
      attr_accessor :public_host, :ssl_path, :ssl_domain, :template_repo, :template_branch

      def initialize(config, homebase)
        jekyll_config = config[:jekyll] || {}

        @enabled         = jekyll_config[:enabled]
        @public_host     = jekyll_config[:public_host]
        @template_repo   = jekyll_config[:template_repo]
        @template_branch = jekyll_config[:template_branch]
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
        :jekyll
      end

      private

    end
  end
end