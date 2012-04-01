gem "mysql2"

# TODO what about Windows?

# if scroll?("eycloud")
#   mysql_versions = [
#     ["MySQL 5.0", "mysql_50"],
#     ["MySQL 5.5 (beta)", "mysql_55"]
#   ]
#   @mysql_stack = multiple_choice("Create app to which Engine Yard Cloud account?", mysql_versions)
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
      prompt: "Create MySQL database with default configuration?"

  - populate_rake_task:
      type: boolean
      prompt: "Add db:sample rake task?"

