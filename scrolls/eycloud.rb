@name = File.basename(File.expand_path("."))

gem_group :development do
  gem 'ey_cli'
  gem 'engineyard'
end

gem 'ey_config' # for partner services

required_dbs = %w[mysql postgresql]
required_app_servers = %w[unicorn trinidad passenger puma thin]

selected_db = required_dbs.find {|db| scroll? db }
unless selected_db
  say_custom "eycloud", "Please include a DB choice from: #{required_dbs.join ", "}"
  exit_now = true
end

selected_app_server = required_app_servers.find {|app| scroll? app }
unless selected_app_server
  say_custom "eycloud", "Please include an App Server choice from: #{required_app_servers.join ", "}"
  exit_now = true
end

exit 1 if exit_now

after_everything do
  @git_url ||= `git config remote.origin.url`.strip
  if @git_url.size == 0
    say_custom "eycloud", "Skipping... no git URI discovered"
  else
    run "ey login"

    if @mysql_stack
      say_custom "eycloud", "Using mysql #{@mysql_stack}"
    elsif @postgresql_stack
      say_custom "eycloud", "Using postgresql #{@postgresql_stack}"
    end
  
    framework_env = multiple_choice "Which framework environment?", [%w[Production production], %w[Staging staging]]


    name = File.basename(".")
    command = "ey_cli create_app --name #{@name} --type rails3 "
    command += "--git #{@git_url} "
    command += "--framework_env #{framework_env} "
    command += "--env_name #{@name}_#{framework_env} "
    command += "--stack #{selected_app_server} "
    command += "--solo"
    run command
  
    # TODO how to get deploy key?
    # How to upload deploy key to github?
  
    # multiple_choice("Let's boot some instances!", [
    #   [""]
    # ])
  end
end

__END__

name: Engine Yard Cloud
description: The Most Powerful Ruby Cloud
author: drnic

requires: [github]
run_after: [github]
category: deployment
exclusive: deployment
