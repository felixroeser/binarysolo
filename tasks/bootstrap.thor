require 'fileutils'
require 'colorize'

class Bootstrap < Thor

  desc "install_deps", "TBA"
  def install_deps
    # FIXME check for vagrant
    # http://files.vagrantup.com/packages/db8e7a9c79b23264da129f55cf8569167fc22415/vagrant_1.3.3_x86_64.deb

    # install plugins
    %w(vagrant-omnibus vagrant-digitalocean).each do |plugin|
      puts `vagrant plugin install #{plugin}`
    end
  end

end