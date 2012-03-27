require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => :spec


desc "Remove the test_run Rails app (if it's there)"
task :clean do
  system 'rm -rf test_run'
end

desc "Execute a test run with the specified scrolls."
task :run => :clean do
  scrolls = ENV['SCROLLS'].split(',')

  require 'tempfile'
  require 'rails_wizard'

  template = RailsWizard::Template.new(scrolls)

  begin
    dir = Dir.mktmpdir "rails_template"
    Dir.chdir(dir) do
      file = File.open('template.rb', 'w')
      file.write template.compile
      file.close  
    
      system "rails new test_run -m template.rb #{template.args.join(' ')}"

      puts "\n\n cd #{dir} # look at the app"
    end
  end
end

desc "Prints out a template from the provided scrolls."
task :print do
  require 'rails_wizard'

  scrolls = ENV['SCROLLS'].split(',')
  puts RailsWizard::Template.new(scrolls).compile
end

desc "Create a new template"
task :new do
  unless (name = ENV['NAME']) && name.size > 0
    $stderr.puts "USAGE: rake new NAME=scroll-name"
    exit 1
  end
  require 'active_support/inflector'
  require 'erb'
  require 'rails_wizard/template'
  scroll = RailsWizard::Template.render("new_scroll", binding)
  scroll_path = "scrolls/#{name}.rb"
  File.open(scroll_path, "w") { |file| file << scroll }
  `open #{scroll_path}`
end