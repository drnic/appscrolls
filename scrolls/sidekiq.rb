gem "sidekiq"
gem "eycloud-recipe-sidekiq"

append_file "deploy/cookbooks/main/recipes/default.rb", <<-RUBY

require_recipe "sidekiq"
RUBY


__END__

name: Sidekiq
description: Simple, efficient message processing for your Rails 3 application
author: drnic

exclusive: worker
category: worker
tags: [worker,background-tasks]

requires: [eycloud_recipes_on_deploy]
run_after: [eycloud_recipes_on_deploy]
