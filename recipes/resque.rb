gem 'resque'
gem 'eycloud-recipe-resque', :group => :eycloud

after_bundler do
  say_wizard 'Adding resque.rake task to lib/tasks'
  create_file "lib/tasks/resque.rake", <<-RAKE
require 'resque/tasks'
RAKE

  say_wizard 'Installing deploy hooks to restart resque after deploys'
  create_file "deploy/before_restart.rb", <<-RUBY
on_app_servers_and_utilities do
  node[:applications].each do |app_name, data|
    sudo 'echo "sleep 20 && monit -g \#{app_name}_resque restart all" | at now'
  end
end
RUBY
end

__END__

name: Resque
description: Add Resque to your application.
author: drnic
website: https://github.com/defunkt/resque

requires: [redis, eycloud_recipes_on_deploy]
run_after: [redis, eycloud_recipes_on_deploy]

category: worker
tags: [background, worker]
exclusive: worker
