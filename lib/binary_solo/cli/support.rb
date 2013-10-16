module BinarySolo
  module CLI
    def self.check_dependencies
      {
        git: 'http://git-scm.com/downloads',
        ansible: 'http://www.ansibleworks.com/docs/intro_installation.html',
        vagrant: 'http://downloads.vagrantup.com/'
      }.each do |cmd, url|
        `which #{cmd}`.present?.tap do |res|
           puts "#{cmd} missing:\nSee #{url}".colorize(:red) unless res
        end
      end.all?
    end
  end
end