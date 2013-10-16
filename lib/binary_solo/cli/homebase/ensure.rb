require 'fileutils'

module BinarySolo
  module CLI
    module Homebase
      class Ensure

        def initialize(args=[], opts={})
        end

        def run
          write_playbook
          ensure_homebase
          run_playbook
        end

        private

        def write_playbook
          pb = BinarySolo::Playbooks.new(BinarySolo.config[:homebase]).save

          BinarySolo.logger.info "Written playbook.yml... with #{pb.components.values.map { |c| c.class.name if c.enabled?}.compact.join(', ') }".colorize(:green)

          true
        end

        def run_playbook
        end

        def ensure_homebase
        end

      end
    end
  end
end