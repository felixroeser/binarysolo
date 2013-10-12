module BinarySolo
  class Homebase
    attr_accessor :config, :provider, :master, :hostname

    def initialize(config)
      @config   = config[:homebase].merge(config[:shared] || {})
      @master   = @config[:master]
      @hostname = @config[:hostname]
      @provider = Provider.find_by_name(config[:provider]).new(config)
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

  end
end
