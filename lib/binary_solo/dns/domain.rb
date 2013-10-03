module BinarySolo
  class Domain

    attr_accessor :name, :records, :provider_id

    def initialize(params={})
      @name    = params[:name]
      @records = (params[:records] || []).collect { |r| DomainRecord.new(r) }
      @provider_id = params[:provider_id]
    end

    def find_record(type, name)
      records.find { |r| r.type == type && r.name == name}
    end

  end
end