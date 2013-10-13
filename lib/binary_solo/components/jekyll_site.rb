module BinarySolo
  module Components
    # FIXME not really a component...
    class JekyllSite
      attr_reader :name, :server, :template_repo, :template_branch, :ssl_path, :ssl_domain

      def initialize(config={})
        @name            = config[:name]
        @server          = config[:public_host]
        @template_repo   = config[:template_repo]
        @template_branch = config[:template_branch]

        @ssl_path    = BinarySolo::Ssl.new.path_for_domain(@server)
        @ssl_domain  = BinarySolo::Ssl.new.path_for_domain(@server, false)
      end

      def valid?
        name.present? && server.present?
      end

      # not used yet
      def for_playbook
        {
          site_name: @name,
          site_server: @server,
          site_template_repo: @site_template_repo,
          site_template_branch: @site_template_branch
        }
      end
    end
  end
end
