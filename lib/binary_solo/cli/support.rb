module BinarySolo
  module CLI
    def self.check_dependencies
      {
        git: 'http://git-scm.com/downloads',
        ansible: 'http://www.ansibleworks.com/docs/intro_installation.html',
        vagrant: 'http://downloads.vagrantup.com/'
      }.each do |cmd, url|
        `which #{cmd}`.present?.tap do |res|
           BinarySolo.logger.error "#{cmd} missing:\nSee #{url}".colorize(:red) unless res
        end
      end.all?
    end

    def self.check_vagrant
      list = `vagrant plugin list`
      %w(vagrant-omnibus vagrant-digitalocean).collect do |p|
        res = list =~ /#{p}/
        BinarySolo.logger.error "Vagrant plugin missing: #{p}" unless res
        res
      end.all?
    end
  end
end