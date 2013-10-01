require_relative 'provider/digital_ocean'

module BinarySolo
  module Provider

    def all
      [DigitalOcean]
    end

    def default
      all.first
    end

    def supported?(name=nil)
      find_by_name(name).present?
    end

    def find_by_name(name=nil) 
      all.find { |p| p.name == name }
    end

    extend self

  end
end
