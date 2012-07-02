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
  require 'appscrolls'

  template = AppScrolls::Template.new(scrolls)

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

desc "Prints out a template from the provided scrolls."
task :print do
  require 'appscrolls'

  scrolls = ENV['SCROLLS'].split(',')
  puts AppScrolls::Template.new(scrolls).compile
end

namespace :list do
  desc "Display scrolls by category"
  task :categories do
    require 'appscrolls'
    categories = AppScrolls::Scrolls.categories.sort
    categories = (categories - ["other"]) + ["other"]
    categories.each do |category|
      puts "#{category}: #{AppScrolls::Scrolls.for(category).join(", ")}"
    end
  end

  # desc "Display scrolls by exclusion"
  # task :exclusions do
  # 
  # end
end
