@name = File.basename(File.expand_path("."))
say_custom "eycloud", "Deploying #{@name} to Engine Yard Cloud..."

# gem 'engineyard-v2', :groups => [:development]
gem 'ey_config'

unless scroll?("mysql") || scroll?("postgresql")
  say_custom "eycloud", "ERROR: To deploy to Engine Yard Cloud, please include 'mysql' or 'postgresql' scroll."
  exit 1
end

after_everything do
  if @mysql_stack
    say_custom "eycloud", "Using mysql #{@mysql_stack}"
  elsif @postgresql_stack
    say_custom "eycloud", "Using postgresql #{@postgresql_stack}"
  end
  
  # run "ey login"
  # 
  # require "yaml"
  # require "engineyard"  # for EY.ui
  # require "engineyard/eyrc" # to load api token
  # require "engineyard-cloud-client"
  # ey_api = EY::CloudClient.new(EY::EYRC.load.api_token)
  # 
  # 
  # say_custom "eycloud", "Fetching list of accounts..."
  # current_apps = EY::CloudClient::App.all(ey_api)
  # 
  # # TODO check if @git_uri is in current_apps, if not then create app
  # 
  # accounts = current_apps.map(&:account).uniq
  # account = multiple_choice("Create app to which Engine Yard Cloud account?", accounts.map {|a| [a.name, a]})
  # 
  # say_custom "eycloud", "Creating application #{@name} on account #{account.name}..."
  # app = EY::CloudClient::App.create(ey_api, {
  #   "account"        => account,
  #   "name"           => @name,
  #   "repository_uri" => @git_uri,
  #   "app_type_id"    => "rails3"
  # })
  # 
  
  # TODO how to get deploy key?
  # How to upload deploy key to github?
  
  # multiple_choice("Let's boot some instances!", [
  #   [""]
  # ])
end

__END__

name: Engine Yard Cloud
description: The Most Powerful Ruby Cloud
author: drnic

requires: [github]
run_after: [github]
category: deployment
exclusive: deployment
