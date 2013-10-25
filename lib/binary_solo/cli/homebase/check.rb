module BinarySolo
  module CLI
    module Homebase
      class Check

        def initialize(args=[], opts={})
          @config = BinarySolo.config
        end

        def run
          true
        end
      end
    end
  end
end