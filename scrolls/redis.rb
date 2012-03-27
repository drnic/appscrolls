gem 'redis'

initializer "redis.rb", <<-RUBY
REDIS = Redis.new
RUBY

if scroll? "eycloud_recipes_on_deploy"
  gem 'eycloud-recipe-redis', :group => :eycloud
end

__END__

name: Redis
description: "Add Redis as a persistence engine to your application."
author: mbleigh

exclusive: key_value
category: persistence
tags: [key_value, cache, session_store]
