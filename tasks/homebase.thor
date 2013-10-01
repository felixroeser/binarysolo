require 'erb'
require 'awesome_print'
require 'colorize'
require 'active_support/core_ext/hash'
require './lib/binary_solo.rb'

class Homebase < Thor

  desc "vagrantfile", "TBA"
  def vagrantfile
    load_config

    if @config['provider'] != 'digitalocean'
      say "...unsupported provider!".colorize(:red)
      exit 1
    end

    BinarySolo::Vagrantfile.new(@config).save

    puts "Written Vagrantfile...".colorize(:green)

    say "Now run:".colorize(:green)
    say "$ thor homebase:playbooks"
  end

  desc "playbooks", "TBA"
  def playbooks
    load_config

    pb = BinarySolo::Playbooks.new(@config).save

    puts "Written playbook.yml...".colorize(:green)

    [:fwd, :gitolite, :stringer, :jekyll].each do |c|
      puts "...#{c} enabled".colorize(:green) if @config[:homebase][c][:enabled]
    end

    say "Now run:".colorize(:green)
    say "$ vagrant up --provider digital_ocean"    
  end

  desc "dns", "TBA"
  def dns
    load_config

    dns = BinarySolo::Dns.new(@config).save
  end

  desc "fwd", "TBA"
  def fwd(port)
    say "tunnel should be up an running!".colorize(:green)
    `ssh -N -i ~/.ssh/binary_solo_rsa -R 8989:localhost:#{port} earl@162.243.128.130`
  end

  # Helpers
  #

  no_commands do

    def load_config
      @config = YAML.load_file('./config/base.yml').with_indifferent_access.deep_merge(YAML.load_file('./config/custom.yml'))
    end

  end

end