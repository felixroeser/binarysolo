require 'fileutils'
require 'colorize'

class Bootstrap < Thor

  desc "install_deps", "TBA"
  def install_deps
    plugins = %w(vagrant-omnibus vagrant-digitalocean)
    puts "Install vagrant plugins #{plugins.join(',' )}".colorize(:green)
    plugins.each do |plugin|
      puts `vagrant plugin install #{plugin}`
    end
  end

end