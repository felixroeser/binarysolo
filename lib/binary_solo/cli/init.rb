require 'fileutils'

module BinarySolo
  module CLI
    class Init
      attr_reader :directory

      def initialize(args=[], opts={})
        @directory = File.expand_path(args.shift || '.binary_solo', '.')

        puts "Creating a new binary_solo project in #{@directory}".colorize(:yellow)
      end

      def valid?
        if File.exist?(directory)
          puts "Directory already exists! Quitting...".colorize(:red)
          return nil
        end

        true
      end

      def run
        return unless valid? && create_directories && copy_templates && init_git

        puts "...all set!".colorize(:green)

        true
      end

      private

      def create_directories
        FileUtils.mkdir_p directory
        FileUtils.touch "#{directory}/.binary_solo"

        %w(ssl config/dns config/homebase ssh).each do |s|
          sub_directory = "#{directory}/#{s}"
          FileUtils.mkdir_p sub_directory
          FileUtils.touch "#{sub_directory}/.gitkeep"
        end        
      end

      def copy_templates        
        template_dir = File.expand_path('../../../../templates/init', __FILE__)
        Dir["#{template_dir}/**/*"].select { |f| File.file?(f) }.each do |f|
          FileUtils.cp(f, f.gsub(template_dir, directory))
        end
      end

      def init_git
        Dir.chdir(directory) do
          File.open('.gitignore', 'w') { |f| f.puts('_provisioning') } rescue nil
          puts `git init`
          puts `git add .`
          puts `git commit -m 'basic file structure'`
        end
        true
      end        

    end
  end
end