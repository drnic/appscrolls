require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => :spec


desc "Remove the test_run Rails app (if it's there)"
task :clean do
  system 'rm -rf test_run'
end

desc "Execute a test run with the specified recipes."
task :run => :clean do
  recipes = ENV['RECIPES'].split(',')

  require 'tempfile'
  require 'rails_wizard'

  template = RailsWizard::Template.new(recipes)

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

desc "Prints out a template from the provided recipes."
task :print do
  require 'rails_wizard'

  recipes = ENV['RECIPES'].split(',')
  puts RailsWizard::Template.new(recipes).compile
end

desc "Create a new template"
task :new do
  unless (name = ENV['NAME']) && name.size > 0
    $stderr.puts "USAGE: rake new NAME=recipe-name"
    exit 1
  end
  require 'active_support/inflector'
  require 'erb'
  require 'rails_wizard/template'
  recipe = RailsWizard::Template.render("new_recipe", binding)
  recipe_path = "recipes/#{name}.rb"
  File.open(recipe_path, "w") { |file| file << recipe }
  `open #{recipe_path}`
end