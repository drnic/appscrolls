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

    # TODO check for app name first
    app_name = (@repo_name && @repo_name.size > 0) ? @repo_name : @name
    say_custom "eycloud", "Checking for availability of #{app_name}"
    @app_names ||= `ey_cli apps | grep "-" | sed "s/.* //"`.split(/\n/)
    while @app_names.include?(app_name)
      app_name = ask_wizard "Application #{app_name} is already exists. What name?"
    end

    name = File.basename(".")
    command = "ey_cli create_app --name #{app_name} --type rails3 "
    command += "--git #{@git_url} "
    command += "--framework_env #{framework_env} "
    command += "--env_name #{@name}_#{framework_env} "
    command += "--stack #{selected_app_server} "
    command += "--solo"
    run command

  end
end

__END__

name: Engine Yard Cloud
description: The Most Powerful Ruby Cloud
author: drnic

category: deployment
exclusive: deployment

requires: [github, eycloud_recipes_on_deploy]
run_after: [github, eycloud_recipes_on_deploy]
