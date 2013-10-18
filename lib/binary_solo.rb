require 'yaml'
require 'erb'
require 'digital_ocean'
require 'domainatrix'
require 'ipaddr'
require 'awesome_print'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'
require 'logger'

require_relative 'binary_solo/universe'
require_relative 'binary_solo/provider'
require_relative 'binary_solo/homebase'
require_relative 'binary_solo/vagrantfile'
require_relative 'binary_solo/playbooks'
require_relative 'binary_solo/ssl'
require_relative 'binary_solo/components'
require_relative 'binary_solo/dns_setup'

module BinarySolo
  def logger
    @logger ||= ::Logger.new(STDOUT).tap { |l| l.level == ::Logger::DEBUG }
  end

  def config
    return @config if @config

    @config = {}.with_indifferent_access

    # config root first, then subdirs
    (Dir[ "#{Dir.pwd}/config/*.yml" ] + Dir[ "#{Dir.pwd}/config/**/*.yml" ]).uniq.each do |f|
      @config.deep_merge! YAML.load_file(f) 
    end

    @config
  end

  # FIXME implement a more sophisticated version in the components
  def config_valid?    
    begin
      return config[:provider] == 'digital_ocean' &&
        config[:homebase][:master].present? &&
        config[:homebase][:ssh_key].present?
    rescue
      nil
    end
  end

  def dir_valid?
    File.exist?("#{Dir.pwd}/.binary_solo")
  end

  def root
    File.expand_path('../../', __FILE__)
  end

  extend self
end