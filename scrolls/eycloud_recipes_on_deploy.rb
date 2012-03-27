gem "engineyard-recipes", :group => [:development]

after_bundler do
  say_custom "eycloud", "Setting up deploy hooks..."
  run "bundle exec ey-recipes init --on-deploy --chef"
  run "bundle update"
end


__END__

name: Recipes on Deploy
description: Run Engine Yard Cloud recipes during deployment instead of independently.
author: drnic
website: https://github.com/engineyard/engineyard-recipes

requires: [eycloud]
run_before: [eycloud]
category: deployment
tags: [background, worker]
