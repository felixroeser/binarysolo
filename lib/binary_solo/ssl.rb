require 'domainatrix'

module BinarySolo
  class Ssl

    def initialize
      @logger = BinarySolo.logger
    end

    def path_for_domain(domain=nil)
      return nil if domain.blank?
      
      puts "Checking for #{domain}"

      url = Domainatrix.parse(domain)
      # FIXME make this configurable
      base_path = File.expand_path('../../../config/ssl', __FILE__)

      path = if File.exist?([base_path, domain].join('/'))
        @logger.debug('ssl available for #{domain}')
        [base_path, domain].join('/')
      elsif File.exist?([base_path, "#{url.domain}.#{url.public_suffix}"].join('/'))
        @logger.debug("ssl not available for #{domain} - but for #{url.domain}.#{url.public_suffix}")
        [base_path, "#{url.domain}.#{url.public_suffix}"].join('/')
      else
        nil
      end

      return nil unless path

      %w(crt key).each do |ext|
        unless File.exist?("#{path}/server.#{ext}")
          @logger.warn "missing #{path}/server.#{ext}".colorize(:red)
          return nil
        end
      end

      path
    end

  end
end