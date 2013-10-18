require 'psych'

module BinarySolo
  class Playbooks
    include ERB::Util
    attr_accessor :config, :components

    def initialize(config)
      @config = config

      provider_name = @config[:provider]
      @provider = Provider.find_by_name(provider_name).new(@config[provider_name])          

      @homebase = Homebase.new(config)

      @components = {
        fwd:      BinarySolo::Components::Fwd.new(@homebase.config, nil),
        jekyll:   BinarySolo::Components::Jekyll.new(@homebase.config, nil),
        stringer: BinarySolo::Components::Stringer.new(@homebase.config, nil),
        gitolite: BinarySolo::Components::Gitolite.new(@homebase.config, nil),
        nginx:    BinarySolo::Components::Nginx.new(@homebase.config, nil)
      }
    end

    def templates
      @templates ||= Dir["#{BinarySolo.root}/templates/provisioning/**/*.erb"].collect do |source|
        {erb: File.read(source), source: source}
      end
    end

    def non_templates
      Dir["#{BinarySolo.root}/templates/provisioning/**/*"].select { |f| f !~ /\.erb\z/i && File.file?(f)  } 
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
      ensure_dirs!
      render.each do |rendered|
        destination = rendered[:source].gsub(BinarySolo.root, @homebase.root).gsub(/\/templates\/provisioning/, '/_provisioning').gsub('.erb', '')
        File.open(destination, 'w+') { |f| f.write rendered[:out] }
      end
      non_templates.each do |f|
        destination = f.gsub(BinarySolo.root, @homebase.root).gsub(/\/templates\/provisioning/, '/_provisioning')
        FileUtils.cp(f, destination)
      end
      self
    end

    def ensure_dirs!
      (templates.collect{ |t| t[:source] } + non_templates).
        collect { |f| File.dirname(f).gsub(BinarySolo.root, @homebase.root).gsub(/\/templates\/provisioning/, '/_provisioning') }.
        uniq.
        each{ |d| FileUtils.mkdir_p(d) }
    end

  end
end
