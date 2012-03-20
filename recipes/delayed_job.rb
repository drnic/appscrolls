gem 'delayed_job'

after_bundler do
  generate 'delayed_job'
end

__END__

name: Delayed Job
description: "Use Delayed Job to handle background jobs"
author: jonochang

exclusive: worker 
category: worker
tags: [worker,background-tasks]

