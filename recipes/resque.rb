gem 'resque'
gem 'eycloud-recipe-resque', :group => :eycloud

say_wizard 'Applying fix suggested in https://github.com/defunkt/resque/pull/403...'
append_file "Rakefile", "\ntask 'resque:setup' => :environment  # for https://github.com/defunkt/resque/pull/403\n"

after_bundler do
  say_wizard 'Adding resque.rake task to lib/tasks'
  create_file "lib/tasks/resque.rake", <<-RAKE
require 'resque/tasks'
RAKE

  say_wizard 'Installing deploy hooks to restart resque after deploys'
  run "touch deploy/before_restart.rb"
  append_file "deploy/before_restart.rb", <<-RUBY
on_app_servers_and_utilities do
  node[:applications].each do |app_name, data|
    sudo 'echo "sleep 20 && monit -g \#{app_name}_resque restart all" | at now'
  end
end
RUBY

  append_file "deploy/cookbooks/main/recipes/default.rb", "\nrequire_recipe 'resque'\n"
  
  unless config['admin_secret'].blank?
    route <<-ROUTE
require "resque/server"
mount Resque::Server.new, :at => "/resque/#{config['admin_secret']}"
ROUTE
    
  end
end

__END__

name: Resque
description: Add Resque to handle background jobs
author: drnic
website: https://github.com/defunkt/resque

requires: [redis, eycloud_recipes_on_deploy]
run_after: [redis, eycloud_recipes_on_deploy]

category: worker
tags: [background, worker]
exclusive: worker

config:
  - admin:
      type: boolean
      prompt: "Install the great admin interface to Delayed Job?"

  - admin_secret:
      type: string
      prompt: "Enter a secret string for the route /resque/YOUR-SECRET-STRING:"
      if: admin