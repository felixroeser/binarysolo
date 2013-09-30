module BinarySolo
  class Vagrantfile
    include ERB::Util
    attr_accessor :config

    def initialize(config)
      @provider_name = config[:provider]
      @provider = config[@provider_name] || {}
      @homebase = config[:homebase]
    end

    def template
      File.read('./templates/homebase.vagrantfile.erb')
    end

    def render()
      ERB.new(template).result(binding)
    end

    def save
      File.open('./Vagrantfile', 'w+') { |f| f.write render }
    end
  end
end
