gem "sidekiq"
# slim/sinatra are used for the sidekiq monitoring UI at /sidekiq/SECRET
gem "slim"
gem "sinatra", ">= 1.3.0", require: false

initializer "sidekiq.rb", <<-RUBY
if $redis_config[:password]
  redis_url = "redis://:\#{$redis_config[:password]}@\#{$redis_config[:host]}:\#{$redis_config[:port]}/sidekiq"
else
  redis_url = "redis://\#{$redis_config[:host]}:\#{$redis_config[:port]}/sidekiq"
end
Rails.logger.info "Setting sidekiq redis: \#{{ url: redis_url, namespace: 'sidekiq' }.inspect}"
Sidekiq.redis = { url: redis_url, namespace: 'sidekiq' }
RUBY

if scroll? "eycloud_recipes_on_deploy"
  gem "eycloud-recipe-sidekiq", :group => :eycloud

  append_file "deploy/cookbooks/main/recipes/default.rb", <<-RUBY

  require_recipe "sidekiq"
  RUBY
end

after_bundler do
  route <<-RUBY
require "sidekiq/web"
  mount Sidekiq::Web, at: "/sidekiq/#{config['sidekiq_admin_secret']}"
  require "sidekiq/api"
  match "queue-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 100 ? "OK" : "UHOH" ]] }
RUBY
end

after_everything do
  if scroll? "cf"
    worker_name = "#{@name}-worker"
    services = $cf_manifest["applications"]["."]["services"]
    manifest_file = cf_standalone_command("worker", worker_name, "bundle exec sidekiq -e production", services)
    cf_delete_app worker_name
    run "vmc _#{@vmc_version}_ push #{worker_name} --runtime #{@cf_ruby_runtime} --path . --manifest #{manifest_file}"
  end
end

__END__

name: Sidekiq
description: Simple, efficient message processing for your Rails 3 application
author: drnic

exclusive: worker
category: worker
tags: [worker,background-tasks]

requires: [redis]
run_after: [redis, eycloud_recipes_on_deploy, cf]

config:
  - sidekiq_admin_secret:
      type: string
      prompt: "Enter a secret string for the route /sidekiq/SECRET:"
