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
end

after_bundler do
  rake "db:create:all" if config['auto_create']
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
