@name = File.basename(File.expand_path("."))

gem_group :development do
  gem 'ey_cli', '>= 0.3.0'
end

gem 'ey_config' # for partner services

required_dbs = %w[mysql postgresql]
required_app_servers = %w[unicorn passenger] # TODO trinidad puma thin

selected_db = required_dbs.find { |db| scroll? db }
unless selected_db
  say_custom "eycloud", "Please include a DB choice from: #{required_dbs.join ", "}"
  exit_now = true
end

selected_app_server = required_app_servers.find { |app| scroll? app }
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
    framework_env = multiple_choice "Which framework environment?", [
      ['Production', 'production'],
      ['Staging (solo environment only)', 'staging']
    ]

    # TODO check for app name first
    app_name = (@repo_name && @repo_name.size > 0) ? @repo_name : @name
    # say_custom "eycloud", "Checking for availability of #{app_name}"
    # @app_names ||= `bundle exec ey_cli apps | grep "-" | sed "s/.* //"`.split(/\n/)
    # while @app_names.include?(app_name)
    #   app_name = ask_wizard "Application #{app_name} is already exists. What name?"
    # end
    
    if framework_env == "production"
      say_custom "eycloud", "All configurations use High-CPU VM worth $170/mth each."
      say_custom "eycloud", "Process numbers below are estimates."
      cluster_config = multiple_choice "Select application cluster configuration?", [
        ['Basic - 1 app VM (5 CPU-based processes) & DB Master VM', 'basic'],
        ['Pro   - 3 app highly-available VMs (15 CPU-based processes) & DB Master VM', 'ha'],
        ['Solo  - 1 VM for app processes, DB and other services', 'solo']
      ]
    else
      say_custom "eycloud", "Defaulting to single/solo High-CPU medium instance for staging environment"
    end

    name = File.basename(".")
    command = "bundle exec ey_cli create_app --name #{app_name} --type rails3 "
    # command += "--account #{account_name} " if account_name
    command += "--git #{@git_url} "
    command += "--framework_env #{framework_env} "
    command += "--env_name #{@name}_#{framework_env} "
    command += "--stack #{selected_app_server} "
    command += "--db_stack #{selected_db} " if selected_db
    case cluster_config.to_sym
    when :basic
      command += "--app_instances 1 "
    when :ha
      command += "--app_instances 3 "
    when :solo
      command += "--solo "
    end
      
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
