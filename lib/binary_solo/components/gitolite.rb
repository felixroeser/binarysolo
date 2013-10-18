module BinarySolo
  module Components
    class Gitolite

      attr_accessor :ssh_key, :public_key

      def initialize(config, homebase)
        gitolite_config = config[:gitolite] || {}

        @enabled     = gitolite_config[:enabled]
        @ssh_key     = File.absolute_path(gitolite_config[:ssh_key] || config[:ssh_key] )
        @public_key =  File.absolute_path("#{config[:ssh_key] || config[:ssh_key] }.pub")
        @homebase    = homebase
      end

      def enabled?
        @enabled
      end

      def self.name
        :gitolite
      end

    end
  end
end