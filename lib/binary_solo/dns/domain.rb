module BinarySolo
  class Domain

    attr_accessor :name, :records, :provider_id

    def initialize(params={})
      @name    = params[:name]
      @records = (params[:records] || []).collect { |r| DomainRecord.new(r) }.select { |r| r.supported?}
      @provider_id = params[:provider_id]
    end

    def find_record(type, name, data=nil)
      records.find do |r| 
        r.type == type && r.name == name && (data.blank? || r.data == data)
      end
    end

  end
end