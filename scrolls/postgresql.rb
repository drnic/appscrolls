gem "pg"

gsub_file "config/database.yml", /username: .*/, "username: #{config['pg_username']}"
gsub_file "config/database.yml", /password: .*/, "username: #{config['pg_password']}"

# if scroll?("eycloud")
#   @db_stack = "postgresql_91"
# end

after_bundler do
  rake "db:create:all" if config['auto_create']
  
  if config['populate_rake_task']
    sample_rake = <<-RUBY
require './config/environment'
namespace :db do
  desc "Populate the database with sample data"
  task :sample do
  end
  task :populate => :sample
end
RUBY
    File.open("lib/tasks/sample.rake", 'w') {|f| f.write(sample_rake)}
  end
end

__END__

name: PostgreSQL
description: Use PostgreSQL for dev & production database
author: drnic

exclusive: orm
category: persistence

run_before: [eycloud]

args: -d postgresql

config:
  - auto_create:
      type: boolean
      prompt: "Create PostgreSQL database with default configuration?"

  - populate_rake_task:
      type: boolean
      prompt: "Add db:sample rake task?"

  - pg_username:
      type: string
      prompt: "PostgreSQL username:"
  - pg_password:
      type: string
      prompt: "PostgreSQL password:"
