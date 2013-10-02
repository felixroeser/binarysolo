module BinarySolo
  class DomainRecord

    attr_reader :type, :name, :data, :priority, :provider_id

    def initialize(params={})
      @type     = params[:type]
      @name     = params[:name]
      @data     = params[:data]
      @priority = params[:priority]
      @port     = params[:port]
      @weight   = params[:weight]

      @provider_id = params[:domain_id]
    end

    def meta?
      ['gmail', 'homebase'].include?(@data)
    end

  end
end