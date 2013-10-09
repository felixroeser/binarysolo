module BinarySolo
  module Components
    class Gitolite

      attr_accessor :ssh_key

      def initialize(config, homebase)
        gitolite_config = config[:gitolite] || {}

        @enabled     = gitolite_config[:enabled]
        @ssh_key     = gitolite_config[:ssh_key]
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