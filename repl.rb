require 'bundler'
Bundler.setup

require_relative 'lib/binary_solo'

@config = BinarySolo.config

provider_name = @config[:provider]
@provider = BinarySolo::Provider.find_by_name(provider_name).new(@config[provider_name])          
@homebase = BinarySolo::Homebase.new(@config)