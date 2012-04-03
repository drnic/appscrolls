gem 'split'
gem 'split', :require => 'split/dashboard'

after_bundler do
  route "mount Split::Dashboard, :at => '/split/#{config['split_admin_secret']}'"
end

__END__

name: Split
description: Rack Based AB testing framework
author: drnic
website: https://github.com/andrew/split
screencast: http://railscasts.com/episodes/331-a-b-testing-with-split

requires: [redis]
run_after: [redis]
run_before: []

category: other
exclusive: ab-testing

config:
  - split_admin_secret:
      type: string
      prompt: "Enter a secret string for the Split dashboard route /split/YOUR-SECRET-STRING:"
