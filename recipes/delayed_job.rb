gem 'delayed_job'
gem 'eycloud-recipe-delayed_job', :group => :eycloud

after_bundler do
  generate 'delayed_job'
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
