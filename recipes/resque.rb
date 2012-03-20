gem 'resque'
gem 'eycloud-recipe-resque'

after_bundler do
  say_wizard 'Adding resque.rake task to lib/tasks'
  create_file "lib/tasks/resque.rake", <<-RAKE
require 'resque/tasks'
RAKE
end

__END__

name: Resque
description: Add Resque to your application.
author: drnic
website: https://github.com/defunkt/resque

requires: [redis]
run_after: redis

category: worker
tags: [background, worker]
exclusive: worker
