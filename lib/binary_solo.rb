require 'bundler'
Bundler.setup
require 'erb'
require 'digital_ocean'
require 'domainatrix'
require 'ipaddr'
require 'awesome_print'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'
require 'logger'

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

  extend self
end