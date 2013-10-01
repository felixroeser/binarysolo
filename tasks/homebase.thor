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
    pb = BinarySolo::Playbooks.new(config).save

    puts "Written playbook.yml...".colorize(:green)

    BinarySolo::Playbooks.components.each do |c|
      puts "...#{c} enabled".colorize if config[:homebase][c][:enabled]
    end

    say "Now run:"
    say "$ vagrant up --provider digital_ocean"    
  end

  desc "dns", "TBA"
  def dns
    ensure_homebase
    
    BinarySolo::Dns.new(config).save
  end

  desc "fwd", "TBA"
  def fwd(port)
    ensure_homebase

    say "reverse tunnel on port #{port} should be up an running!".colorize(:green)
    say "kill the connection with Control-C"

    `ssh -N -R 8989:localhost:#{port} #{homebase.master}@#{homebase.current_ip}`
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
      return if homebase.exists?
      say "Your homebase is not up and running!".colorize(:red)
      exit 1
    end

  end

end