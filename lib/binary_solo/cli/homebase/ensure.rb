require 'fileutils'

module BinarySolo
  module CLI
    module Homebase
      class Ensure

        def initialize(args=[], opts={})
          @config = BinarySolo.config
        end

        def run
          write_vagrantfile
          write_playbook
          ensure_homebase
        end

        private

        def write_vagrantfile 
          BinarySolo::Vagrantfile.new(@config).save
          BinarySolo.logger.info "Written Vagrantfile...".colorize(:green)
        end

        def write_playbook
          pb = BinarySolo::Playbooks.new(BinarySolo.config).save
          BinarySolo.logger.info "Written playbook.yml... with #{pb.components.values.map { |c| c.class.name if c.enabled?}.compact.join(', ') }".colorize(:green)
          true
        end

        def ensure_homebase
          current_status = `vagrant status | grep homebase`.chomp
          if current_status =~ /not created/
            BinarySolo.logger.info "Bringing up homebase"
            # FIXME remove hardcoded provider
            run_cmd "vagrant up --provider #{@config[:provider]}"
          elsif current_status =~ /running|active/
            BinarySolo.logger.info "Provisioning homebase"
            run_cmd "vagrant provision"
          else
            BinarySolo.logger.warn "Dont know what to do with #{current_status}"
          end
        end

        def run_cmd(cmd)
          IO.popen(cmd) do |output| 
            while line = output.gets do
                puts line
            end
          end          
        end

      end
    end
  end
end