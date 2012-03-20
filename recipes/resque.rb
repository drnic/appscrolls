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
  create_file "deploy/before_restart.rb", <<-RUBY
on_app_servers_and_utilities do
  node[:applications].each do |app_name, data|
    sudo 'echo "sleep 20 && monit -g \#{app_name}_resque restart all" | at now'
  end
end
RUBY

  append_file "deploy/cookbooks/main/recipes/default.rb", "\nrequire_recipe 'resque'\n"
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
