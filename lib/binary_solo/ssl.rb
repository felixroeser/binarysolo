require 'domainatrix'

module BinarySolo
  class Ssl

    def initialize(homebase=nil)
      @logger   = BinarySolo.logger
      @homebase = homebase
    end

    def path_for_domain(domain=nil, full=true)
      return nil if domain.blank?
      
      url = Domainatrix.parse(domain)
      path = if File.exist?([base_path, domain].join('/'))
        @logger.debug("ssl available for #{domain}")
        [base_path, domain]
      elsif File.exist?([base_path, "#{url.domain}.#{url.public_suffix}"].join('/'))
        @logger.debug("ssl not available for #{domain} - but for #{url.domain}.#{url.public_suffix}")
        [base_path, "#{url.domain}.#{url.public_suffix}"]
      else
        nil
      end

      return nil unless path

      %w(crt key).each do |ext|
        unless File.exist?("#{path.join('/')}/server.#{ext}")
          @logger.warn "missing #{path.join('/')}/server.#{ext}".colorize(:red)
          return nil
        end
      end

      full ? path.join('/') : path.last
    end

    def base_path
      path = "#{@homebase.try(&:root) || Dir.pwd}/ssl"

      File.exist?(path) ? path : nil
    end

    def files_for_nginx
      return [] unless base_path
      Dir["#{base_path}/**/*"].
        select { |f| f =~ /\.(crt|key)\z/ }.
        collect { |f| f.gsub(base_path, '') }
    end

    def ssl_directories
      files_for_nginx.collect { |f| File.dirname("#{base_path}#{f}").split('/').last }.uniq
    end

  end
end