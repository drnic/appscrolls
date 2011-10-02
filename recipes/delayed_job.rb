gem 'tobi-delayed_job'

after_everything do
  generate 'delayed_job'
end

__END__

name: Delayed Job
description: "Use Delayed Job to handle background jobs"
author: jonochang

exclusive: background-tasks 
category: background-tasks
tags: [background-tasks]

