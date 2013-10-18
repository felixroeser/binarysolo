# -*- encoding: utf-8 -*-
require File.expand_path('../lib/binary_solo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Felix Roeser']
  gem.email         = ['fr@xilef.me']
  gem.description   = 'Serving your hacker homebase'
  gem.summary       = ''
  gem.homepage      = 'https://github.com/felixroeser/binarysolo'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = 'binary_solo'
  gem.require_paths = ['lib']
  gem.version       = BinarySolo::VERSION

  gem.add_dependency 'trollop', '~> 2.0.0'
  gem.add_dependency 'thor'
  gem.add_dependency 'active_support', '>= 3.0'
  gem.add_dependency 'awesome_print'
  gem.add_dependency 'colorize'
  gem.add_dependency 'highline'
  gem.add_dependency 'digital_ocean'
  gem.add_dependency 'domainatrix'
  gem.add_dependency 'whois'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-given'
end