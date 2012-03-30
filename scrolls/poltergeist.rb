gem 'poltergeist'

after_bundler do
  append_to_file 'features/support/env.rb', <<-RUBY
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
RUBY
end

__END__

name: Poltergeist
description:
author: drnic
website:

requires: []
run_after: [capybara, cucumber]
run_before: []

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
