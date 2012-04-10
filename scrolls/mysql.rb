gem "mysql2"

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

name: MySQL
description: Use MySQL for dev & production database
author: drnic

exclusive: orm
category: persistence

run_before: [eycloud]

args: -d mysql

config:
  - auto_create:
      type: boolean
      prompt: "Create local MySQL databases with default configuration?"
