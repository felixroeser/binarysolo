module BinarySolo
  class Universe
    attr_reader :config, :name

    def initialize(config={})
      @config = config
      @name   = @config[:name]
    end

  end
end
