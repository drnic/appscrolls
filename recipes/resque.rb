gem 'resque'

after_bundler do
  say_wizard 'Adding resque.rake task to lib/tasks'
  create_file "lib/tasks/resque.rake", <<-RAKE
require 'resque/tasks'
RAKE
end

__END__

name: Resque
description: "Add Resque to your application."
author: porta

category: worker
tags: [background, worker]

requires: [redis]
run_after: redis
