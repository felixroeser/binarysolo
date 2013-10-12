require 'erb'
require 'awesome_print'
require 'colorize'
require 'active_support/core_ext/hash'
require './lib/binary_solo.rb'

class Homebase < Thor

  desc "vagrantfile", "TBA"
  def vagrantfile
    if BinarySolo::Vagrantfile.new(config).save
      say "Written Vagrantfile...".colorize(:green)
      say "Now run:"
      say "$ thor homebase:playbooks"
    else
      say "Something went wrong...".colorize(:red)
    end
  end

  desc "playbooks", "TBA"
  def playbooks
    pb = BinarySolo::Playbooks.new(homebase.config).save

    BinarySolo.logger.info "Written playbook.yml... with #{pb.components.values.map { |c| c.class.name if c.enabled?}.compact.join(', ') }".colorize(:green)

    say "Now run:"
    say "$ vagrant up --provider digital_ocean"    
    say " or "
    say "$ vagrant provision"
  end

  desc "dns_setup", "TBA"
  def dns_setup
    ensure_homebase

    BinarySolo::DnsSetup.new(config, homebase).save
  end

  desc "fwd", "TBA"
  def fwd(port)
    ensure_homebase

    fwd = BinarySolo::Components::Fwd.new(config, homebase)

    say "reverse tunnel on port #{port} should be up an running at http://#{fwd.public_host}!".colorize(:green)
    say "kill the connection with Control-C"

    fwd.up(port)
  end

  # Helpers
  #

  no_commands do

    def config
      @config ||= YAML.load_file('./config/base.yml').with_indifferent_access.deep_merge(YAML.load_file('./config/custom.yml'))
    end

    def homebase
      @homebase ||= BinarySolo::Homebase.new(config)
    end

    def ensure_homebase
      return true if homebase.exists?
      say "Your homebase is not up and running!".colorize(:red)
      exit 1
    end

  end

end
