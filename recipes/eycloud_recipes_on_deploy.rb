gem "engineyard-recipes", :group => [:development]

after_bundler do
  puts `bundle exec ey-recipes init --on-deploy`
end


__END__

name: Recipes on Deploy
description: Run Engine Yard Cloud recipes during deployment instead of independently.
author: drnic
website: https://github.com/engineyard/engineyard-recipes

requires: [eycloud]
run_after: [eycloud]
category: deployment
tags: [background, worker]
