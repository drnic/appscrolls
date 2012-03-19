if config['database']
  say_wizard "Configuring '#{config['database']}' database settings..."
  old_gem = gem_for_database
  @options = @options.dup.merge(:database => config['database'])

  # SQLite3 gem requires special treatment.
  gem_string = case gem_for_database
  when "sqlite3"; "gem 'sqlite3-ruby', :require => 'sqlite3'"
  when "mysql2"; "gem 'mysql2', '~> 0.2.6'"
  else "gem '#{gem_for_database}'"
  end
  gsub_file 'Gemfile', Regexp.new("gem '#{old_gem}'(, '[^']*')?(, :require => '[^']*')?"), gem_string

  template "config/databases/#{@options[:database]}.yml", "config/database.yml.new"
  run 'mv config/database.yml.new config/database.yml'
  puts "db: #{@options[:database]}"
  puts "postgres_role: #{config['postgres_role']}"
  if @options[:database] == 'postgresql'
    role = ask_wizard("Please enter role:")
    run "createuser -U postgres -d #{role}" unless role.blank?
  end
end

after_bundler do
  rake "db:create:all" if config['auto_create']
  
  if config['populate_rake_task']
    populate_rake = <<-RB
require './config/environment'
namespace :db do
  desc "Populate the database with sample data"
  task :populate do
  end
end
RB
    File.open("lib/tasks/populate.rake", 'w') {|f| f.write(populate_rake)}
  end
end

__END__

name: ActiveRecord
description: "Use the default ActiveRecord database store."
author: mbleigh

exclusive: orm
category: persistence
tags: [sql, defaults, orm]

config:
  - database:
      type: multiple_choice
      prompt: "Which database are you using?"
      choices:
        - ["MySQL", mysql]
        - ["Oracle", oracle]
        - ["PostgreSQL", postgresql]
        - ["SQLite", sqlite3]
        - ["Frontbase", frontbase]
        - ["IBM DB", ibm_db]

  - auto_create:
      type: boolean
      prompt: "Automatically create database with default configuration?"
  
  - populate_rake_task:
      type: boolean
      prompt: "Add db:populate rake task?"

