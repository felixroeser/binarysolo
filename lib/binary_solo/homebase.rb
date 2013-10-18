module BinarySolo
  class Homebase
    attr_accessor :config, :provider, :master, :hostname, :ssh_key

    def initialize(config)
      @config   = config[:homebase].merge(config[:shared] || {})
      @master   = @config[:master]
      @hostname = @config[:hostname]
      @ssh_key  = @config[:ssh_key]
      @provider = Provider.find_by_name(config[:provider]).new(config[config[:provider]])
    end

    def exists?
      current_ip.present?
    end

    def current_ip
      current_droplet['ip_address'] rescue nil
    end

    def current_droplet
      @current_droplet ||= @provider.find_droplet_by_name('homebase')
    end

    def root
      File.absolute_path('.')
    end

    def valid?
      ssh_key_present?
    end

    def ssh_key_present?
      File.exist?(ssh_key) && File.exist?("#{ssh_key}.pub")
    end

    def ssh_pub_key
      File.read("#{ssh_key}.pub").chomp
    end


  end
end
