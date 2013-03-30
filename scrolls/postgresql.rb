gsub_file "config/database.yml", /username: .*/, "username: #{config['pg_username']}"
gsub_file "config/database.yml", /password: .*/, "password: #{config['pg_password']}"
%w[development test production].each do |env|
  gsub_file "config/database.yml", /^#{env}:/, "#{env}:\n  host: localhost"
end

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

run_before: [eycloud, cf]

args: -d postgresql

config:
  - pg_username:
      type: string
      prompt: "Local development PostgreSQL username:"
  - pg_password:
      type: string
      prompt: "Local development PostgreSQL password:"
