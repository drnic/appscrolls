gem "pg"

gsub_file "config/database.yml", /username: .*/, "username: #{config['pg_username']}"
gsub_file "config/database.yml", /password: .*/, "password: #{config['pg_password']}"

after_bundler do
  rake "db:create:all" if config['auto_create']
  
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

run_before: [eycloud]

args: -d postgresql

config:
  - auto_create:
      type: boolean
      prompt: "Create local PostgreSQL databases with default configuration?"

  - pg_username:
      type: string
      prompt: "PostgreSQL username:"
  - pg_password:
      type: string
      prompt: "PostgreSQL password:"
