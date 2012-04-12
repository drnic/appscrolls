gem "pg"

after_bundler do
  pg_username = ask_wizard "Local development PostgreSQL username:"
  pg_password = ask_wizard "Local development PostgreSQL password:"

  gsub_file "config/database.yml", /username:\s?.*/, "username: #{pg_username}"
  gsub_file "config/database.yml", /password:\s?.*/, "password: #{pg_password}"

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

run_before: [eycloud]

args: -d postgresql
