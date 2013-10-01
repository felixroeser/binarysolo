require 'bundler'
Bundler.setup
require 'erb'
require 'digital_ocean'
require 'domainatrix'
require 'ipaddress'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'

require_relative 'binary_solo/provider'
require_relative 'binary_solo/homebase'
require_relative 'binary_solo/vagrantfile'
require_relative 'binary_solo/playbooks'
require_relative 'binary_solo/dns'