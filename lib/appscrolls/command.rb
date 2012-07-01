require 'appscrolls'
require 'thor'
require File.dirname(__FILE__) + "/../../version"

module AppScrolls
  class Command < Thor
    include Thor::Actions

    desc "version", "show version of currently installed AppScrolls gem"
    def version
      puts "AppScrolls version #{AppScrolls::VERSION} ready to make magic."
    end

    desc "new APP_NAME", "create a new Rails app"
    method_option :scrolls, :type => :array, :aliases => "-s", :desc => "List scrolls, e.g. -s resque rails_basics jquery"
    method_option :template, :type => :boolean, :aliases => "-t", :desc => "Only display template that would be used"
    method_option :config, :type => :string, :aliases => "-c", :desc => "Path to config script to run before scrolls"
    def new(name)
      config_file = options[:config] || ENV['APPSCROLLS_CONFIG']
      if options[:scrolls]
        run_template(name, options[:scrolls], :display_only => options[:template], :config_file => config_file)
      else
        @scrolls = []

        question = "#{bold}Which scroll would you like to add/remove? #{clear}#{yellow}(blank to finish)#{clear}"
        while (scroll = ask(scrolls_message + question)) != ''
          if @scrolls.include?(scroll)
            @scrolls.delete(scroll)
            puts
            puts "> #{yellow}Removed '#{scroll}' from template.#{clear}"
          elsif AppScrolls::Scrolls.list.include?(scroll)
            @scrolls << scroll
            puts
            puts "> #{green}Added '#{scroll}' to template.#{clear}"
          else
            puts
            puts "> #{red}Invalid scroll, please try again.#{clear}"
          end
        end

        run_template(name, @scrolls, :display_only => options[:template], :config_file => config_file)
      end
    end

    desc "list [CATEGORY]", "list available scrolls (optionally by category)"
    def list(category = nil)
      if category
        scrolls = AppScrolls::Scrolls.for(category).map{|r| AppScrolls::Scroll.from_mongo(r) }
      else
        scrolls = AppScrolls::Scrolls.list_classes
      end

      scrolls.each do |scroll|
        puts scroll.key.ljust(15) + "# #{scroll.description}"
      end
    end

    no_tasks do
      def cyan; "\033[36m" end
      def clear; "\033[0m" end
      def bold; "\033[1m" end
      def red; "\033[31m" end
      def green; "\033[32m" end
      def yellow; "\033[33m" end

      def scrolls_message
        message = "\n\n\n"
        if @scrolls && @scrolls.any?
          message << "#{green}#{bold}Your Scrolls:#{clear} #{@scrolls.join(", ")}"
          message << "\n\n"
        end
        available_scrolls = AppScrolls::Scrolls.list - @scrolls
        if available_scrolls.any?
          message << "#{bold}#{cyan}Available Scrolls:#{clear} #{available_scrolls.join(', ')}"
          message << "\n\n"
        end
        message
      end

      def run_template(name, scrolls, options = {})
        puts
        puts
        puts "#{bold}Generating and Running Template...#{clear}"
        puts
        file = Tempfile.new('template')
        template_options = {}
        template_options[:config_script] = File.read(options[:config_file]) if options[:config_file]
        template = AppScrolls::Template.new(scrolls, template_options)

        puts "Using the following scrolls:"
        template.resolve_scrolls.map do |scroll|
          color = scrolls.include?(scroll.new.key) ? green : yellow # yellow - automatic dependency
          puts "  #{color}* #{scroll.new.name}#{clear}"
        end
        puts

        file.write template.compile
        file.close
        if options[:display_only]
          puts "Template stored to #{file.path}"
          puts File.read(file.path)
        else
          system "rails new #{name} -m #{file.path} #{template.args.join(' ')}"
        end
      ensure
        file.unlink unless options[:display_only]
      end
    end
  end
end
