require 'bundler'
Bundler.setup
require 'digital_ocean'
require 'domainatrix'
require 'ipaddress'

require_relative 'binary_solo/vagrantfile'
require_relative 'binary_solo/playbooks'
require_relative 'binary_solo/dns'