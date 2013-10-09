module BinarySolo
  module Components
    class Gitolite

      def initialize(config, homebase)
        gitolite_config = config[:gitolite] || {}

        @enabled     = gitolite_config[:enabled]
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