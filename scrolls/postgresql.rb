gem "pg"

after_bundler do
  require 'pg'

  pg_username = ask_wizard "Local development PostgreSQL username:"
  pg_password = ask_wizard "Local development PostgreSQL password:"

  # attempt to connect to PostgreSQL using username and password
  params = { :dbname => 'template1', :user => pg_username }
  params[:password] = pg_password unless pg_password.blank?

  begin
    dbh = PG::Connection.new params
    dbh.finish

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
  rescue PG::Error => err
    # surely there's a better way to report errors than this....
    puts err.to_s
    exit 1
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
