module BinarySolo
  class Domain

    attr_reader :name, :records, :provider_id

    def initialize(params={})
      @name    = params[:name]
      @records = (params[:records] || []).collect { |r| DomainRecord.new(r) }
      @provider_id = params[:provider_id]
    end

  end
end