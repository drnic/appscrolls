require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => :spec


desc "Remove the test_run Rails app (if it's there)"
task :clean do
  system 'rm -rf test_run'
end

namespace :run do
  desc "Execute a test run with the specified scrolls on a new Rails app"
  task :new => :clean do
    scrolls = ENV['SCROLLS'].split(',')

    require 'tempfile'
    require 'rails_wizard'

    template = EldarScrolls::Template.new(scrolls)

    begin
      dir = Dir.mktmpdir "rails_template"
      Dir.chdir(dir) do
        file = File.open('template.rb', 'w')
        file.write template.compile
        file.close

        system "rails new test_run -m template.rb #{template.args.join(' ')}"

        puts "\n\n cd #{dir} # look at the app"
        puts "#{ENV['EDITOR']} #{dir} # edit the app"
      end
    end
  end

  desc "Execute a test run with the specified scrolls on an existing Rails app"
  task :apply => :clean do
    scrolls = ENV['SCROLLS'].split(',')

    require 'tempfile'
    require 'rails_wizard'

    template = EldarScrolls::Template.new(scrolls)

    begin
      dir = Dir.mktmpdir "rails_template"
      Dir.chdir(dir) do
        file = File.open('template.rb', 'w')
        file.write template.compile
        file.close
    
        system "rails new test_run && cd test_run && FIXME!"

        puts "\n\n cd #{dir} # look at the app"
        puts "#{ENV['EDITOR']} #{dir} # edit the app"
      end
    end
  end
end

desc "Prints out a template from the provided scrolls."
task :print do
  require 'eldarscrolls'

  scrolls = ENV['SCROLLS'].split(',')
  puts EldarScrolls::Template.new(scrolls).compile
end

desc "Create a new scroll"
task :new do
  unless (name = ENV['NAME']) && name.size > 0
    $stderr.puts "USAGE: rake new NAME=scroll-name"
    exit 1
  end
  require 'active_support/inflector'
  require 'erb'
  require 'eldarscrolls/template'
  scroll = EldarScrolls::Template.render("new_scroll", binding)
  scroll_path = "scrolls/#{name}.rb"
  File.open(scroll_path, "w") { |file| file << scroll }
  `open #{scroll_path}`
end

namespace :list do
  desc "Display scrolls by category"
  task :categories do
    require 'eldarscrolls'
    categories = EldarScrolls::Scrolls.categories.sort
    categories = (categories - ["other"]) + ["other"]
    categories.each do |category|
      puts "#{category}: #{EldarScrolls::Scrolls.for(category).join(", ")}"
    end
  end

  # desc "Display scrolls by exclusion"
  # task :exclusions do
  # 
  # end
end