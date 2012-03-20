gem 'delayed_job_active_record'
gem 'eycloud-recipe-delayed_job', :group => :eycloud
gem 'delayed_job_admin'


after_bundler do
  generate 'delayed_job'

  say_wizard 'Installing deploy hooks to restart delayed_job after deploys'
  run "touch deploy/before_restart.rb"
  append_file "deploy/before_restart.rb", <<-RUBY
on_app_servers_and_utilities do
  node[:applications].each do |app_name, data|
    sudo 'echo "sleep 20 && monit -g dj_\#{app_name} restart all" | at now'
  end
end
RUBY

  append_file "deploy/cookbooks/main/recipes/default.rb", "\nrequire_recipe 'delayed_job'\n"
end

__END__

name: Delayed Job
description: Use Delayed Job to handle background jobs
author: drnic

exclusive: worker 
category: worker
tags: [worker,background-tasks]

requires: [eycloud_recipes_on_deploy]
run_after: [eycloud_recipes_on_deploy]

config:
  - admin:
      type: boolean
      prompt: "Install simple admin interface to Delayed Job?"
