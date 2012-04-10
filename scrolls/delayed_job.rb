gem 'delayed_job_active_record'
gem 'delayed_job_admin'

inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
<<-RUBY

def delayed_job_admin_authentication
  # authentication_logic_goes_here
  true
end

RUBY
end

create_file "readmes/delayed_job_admin.md", <<-MD
# Delayed Job Admin README

Delayed Job Admin console is available at [/delayed_job_admin](http://localhost:3000/delayed_job_admin).

```
open http://localhost:3000/delayed_job_admin
```

## Steps to complete

### Authentication

By default, there is no authentication or authorization protecting access to `/delayed_job_admin`.

Please go to `app/controllers/application_controller.rb` and edit the following method:

```ruby
def delayed_job_admin_authentication
  # authentication_logic_goes_here
  true
end
```

For example, if you are using the Devise gem and have an Admin model:

```ruby
def delayed_job_admin_authentication
  authenticate_admin!
end
```

MD

if scroll? "eycloud_recipes_on_deploy"
  gem 'eycloud-recipe-delayed_job', :group => :eycloud
end


after_bundler do
  generate 'delayed_job'

  if scroll? "eycloud_recipes_on_deploy"
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
end

__END__

name: Delayed Job
description: Use Delayed Job to handle background jobs
author: drnic

exclusive: worker 
category: worker
tags: [worker,background-tasks]

run_after: [eycloud_recipes_on_deploy, mysql, postgresql]
