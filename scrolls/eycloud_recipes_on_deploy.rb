gem "engineyard-scrolls", :group => [:development]

after_bundler do
  say_custom "eycloud", "Setting up deploy hooks..."
  run "bundle exec ey-scrolls init --on-deploy --chef"
  run "bundle update"
end


__END__

name: Recipes on Deploy
description: Run Engine Yard Cloud scrolls during deployment instead of independently.
author: drnic
website: https://github.com/engineyard/engineyard-scrolls

requires: [eycloud]
run_after: [eycloud]
category: deployment
tags: [background, worker]
