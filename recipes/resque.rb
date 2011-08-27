gem 'resque'

after_bundler do
  say_wizard 'Adding resque.rake task to lib/tasks'
  file 'lib/tasks/resque.rake', "require 'resque/tasks'\n"
end

__END__

name: Resque
description: "Add Resque to your application."
author: porta

category: worker
tags: [background, worker]

requires: redis
run_after: redis
