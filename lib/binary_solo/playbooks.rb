module BinarySolo
  class Playbooks
    include ERB::Util
    attr_accessor :config, :components

    def initialize(config)
      @config = config

      @components = {
        fwd:      BinarySolo::Components::Fwd.new(@config, nil),
        jekyll:   BinarySolo::Components::Jekyll.new(@config, nil),
        stringer: BinarySolo::Components::Stringer.new(@config, nil),
        gitolite: BinarySolo::Components::Gitolite.new(@config, nil),
        nginx:    BinarySolo::Components::Nginx.new(@config, nil)
      }
    end

    def templates
      @templates ||= Dir['./templates/provisioning/**/*.erb'].collect do |source|
        {erb: File.read(source), source: source}
      end
    end

    def non_templates
      Dir['./templates/provisioning/**/*'].select { |f| f !~ /\.erb\z/i && File.file?(f)  } 
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
        destination = rendered[:source].gsub(/^\.\/templates\/provisioning/, './_provisioning').gsub('.erb', '')
        File.open(destination, 'w+') { |f| f.write rendered[:out] }
      end
      non_templates.each do |f|
        FileUtils.cp(f, f.gsub(/^\.\/templates\/provisioning/, './_provisioning'))
      end
      self
    end

    def ensure_dirs!
      FileUtils.mkdir('./_provisioning') rescue Errno::EEXIST
      (templates.collect{ |t| t[:source] } + non_templates).
        collect { |f| File.dirname(f) }.
        uniq.
        each{ |d| FileUtils.mkdir_p(d.gsub(/^\.\/templates\/provisioning/, './_provisioning')) }
    end

  end
end
