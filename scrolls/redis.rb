gem 'redis'

initializer "redis.rb", <<-RUBY
if ENV['VCAP_SERVICES']
  $vcap_services ||= JSON.parse(ENV['VCAP_SERVICES'])
  redis_service_name = $vcap_services.keys.find { |svc| svc =~ /redis/i }
  redis_service = $vcap_services[redis_service_name].first
  $redis_config = {
    host: redis_service['credentials']['host'],
    port: redis_service['credentials']['port'],
    password: redis_service['credentials']['password']
  }
else
  $redis_config = {
    host: '127.0.0.1',
    port: 6379
  }
end

$redis = Redis.new($redis_config)

if $redis_config[:password]
  $redis_url = "redis://:#{$redis_config[:password]}@#{$redis_config[:host]}:#{$redis_config[:port]}/0"
else
  $redis_url = "redis://#{$redis_config[:host]}:#{$redis_config[:port]}/0"
end
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
