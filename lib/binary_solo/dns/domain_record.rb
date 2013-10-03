module BinarySolo
  class DomainRecord

    attr_accessor :type, :name, :data, :priority, :provider_id

    def initialize(params={})
      @type     = params[:type]
      @name     = params[:name]
      @data     = params[:data]
      @priority = params[:priority]
      @port     = params[:port]
      @weight   = params[:weight]

      @provider_id        = params[:provider_id] || params[:id]
      @domain_provider_id = params[:domain_id]
    end

    def meta?
      ['gmail', 'homebase'].include?(@data) ? @data : nil
    end

    def supported?
      return false unless %w(A CNAME TXT MX).include?(@type)

      true
    end

    def meta_replacements
      return [self] unless @type == 'MX' && meta? == 'gmail'

      [ [1, 'ASPMX.L.GOOGLE.COM.'], [5, 'ALT1.ASPMX.L.GOOGLE.COM.'], [5, 'ALT2.ASPMX.L.GOOGLE.COM.'],
        [10, 'ASPMX2.GOOGLEMAIL.COM.'], [10, 'ASPMX3.GOOGLEMAIL.COM.']
      ].collect do |(priority, data)|
        DomainRecord.new(type: 'MX', data: data, priority: priority)
      end
    end

  end
end