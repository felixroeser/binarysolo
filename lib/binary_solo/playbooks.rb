module BinarySolo
  class Playbooks
    include ERB::Util
    attr_accessor :config, :components

    def initialize(config)
      @config = config[:homebase]

      @components = {
        fwd:    BinarySolo::Components::Fwd.new(@config),
        jekyll: BinarySolo::Components::Jekyll.new(@config)
      }
    end

    def templates
      @templates ||= Dir['./templates/provisioning/**/*.erb'].collect do |source|
        {erb: File.read(source), source: source}
      end
    end

    def render
      @rendered ||= templates.collect do |template|
        out = ERB.new(template[:erb])
          .result(binding)
          .split("\n")
          .select { |line| line.present? }
          .compact
          .join("\n")
        {out: out, source: template[:source] }
      end
    end

    def save
      render.each do |rendered|
        destination = rendered[:source].gsub(/^\.\/templates/, '.').gsub('.erb', '')
        File.open(destination, 'w+') { |f| f.write rendered[:out] }
      end
      self
    end

  end
end
