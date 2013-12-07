module BinarySolo
  # TODO not really utilized right now
  class Universe
    attr_reader :config, :name

    def initialize(config={})
      @config = config
      @name   = @config[:name]
    end

  end
end
