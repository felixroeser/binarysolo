# -*- encoding: utf-8 -*-
require File.expand_path('../lib/binary_solo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Felix Roeser']
  gem.email         = ['fr@xilef.me']
  gem.description   = 'Serving your hacker homebase'
  gem.summary       = 'Host Stringer on a cheap digital ocean box and add some goodies like gitolite, jekyll and a http reverse proxy fully managed with Vagrant and Ansible'
  gem.homepage      = 'https://github.com/felixroeser/binarysolo'
  gem.license        = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = 'binary_solo'
  gem.require_paths = ['lib']
  gem.version       = BinarySolo::VERSION

  gem.add_dependency 'trollop', '~> 2.0.0'
  gem.add_dependency 'thor', '~> 0.18.1'
  gem.add_dependency 'active_support', '>= 3.0'
  gem.add_dependency 'awesome_print', '~> 1.2'
  gem.add_dependency 'colorize', '~> 0.6.0'
  gem.add_dependency 'highline', '~> 1.6.19'
  # See Gemfile gem.add_dependency 'digital_ocean', '~> 1.2.0'
  gem.add_dependency 'domainatrix', '~> 0.0.11'
  gem.add_dependency 'whois', '~> 3.3.1'

  gem.add_development_dependency 'rspec', '~> 2.14.1'
  gem.add_development_dependency 'rspec-given', '~> 3.1.1'
end