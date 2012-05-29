gem "sidekiq"

if scroll? "eycloud_recipes_on_deploy"
  gem "eycloud-recipe-sidekiq", :group => :eycloud

  append_file "deploy/cookbooks/main/recipes/default.rb", <<-RUBY

  require_recipe "sidekiq"
  RUBY
end

__END__

name: Sidekiq
description: Simple, efficient message processing for your Rails 3 application
author: drnic

exclusive: worker
category: worker
tags: [worker,background-tasks]

requires: [redis]
run_after: [redis, eycloud_recipes_on_deploy]
