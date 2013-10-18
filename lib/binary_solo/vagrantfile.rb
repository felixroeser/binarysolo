module BinarySolo
  class Vagrantfile
    include ERB::Util
    attr_accessor :config

    def initialize(config)
      @provider = Provider.find_by_name(config[:provider]).new(config[config[:provider]])
      @homebase = Homebase.new(config)
    end

    def template
      File.read("#{BinarySolo.root}/templates/homebase.vagrantfile.erb")
    end

    def render()
      ERB.new(template).result(binding)
    end

    def save
      return nil unless @provider
      File.open("#{@homebase.root}/Vagrantfile", 'w+') { |f| f.write render }
    end
  end
end
