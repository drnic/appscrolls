# No need to specify gem because rails generator will do that

# Update database.yml
gsub_file "config/database.yml", /username: .*/, "username: #{config['pg_username']}"
gsub_file "config/database.yml", /password: .*/, "password: #{config['pg_password']}"

# Add service rake tasks
add_service :postgres, 
            "#{config['pg_path']}/postmaster.pid", 
            "pg_ctl -D #{config['pg_path']} start", 
            "pg_ctl -D #{config['pg_path']} stop"

after_bundler do
  rake "db:create:all"
  
  rakefile("sample.rake") do
<<-RUBY
namespace :db do
  desc "Populate the database with sample data"
  task :sample => :environment do

  end
  task :populate => :sample
end
RUBY
  end
end

__END__

name: PostgreSQL
description: Use PostgreSQL for dev & production database
author: drnic

exclusive: orm
category: persistence

run_after: [services]

args: -d postgresql

config:
  - pg_username:
      type: string
      prompt: "Local development PostgreSQL username:"
  - pg_password:
      type: string
      prompt: "Local development PostgreSQL password:"
  - pg_path:
      type: string
      prompt: "Path to your local PGDATA:"

