gem 'spork', '~> 1.0.rc'

after_bundler do
  run "bundle exec spork --bootstrap"
end

__END__

name: Spork
description: DRb server for testing frameworks that forks before each run to ensure a clean testing state
author: drnic
website: https://github.com/sporkrb/spork

requires: []
run_after: []
run_before: []

category: testing
# exclusive: 
