gem "engineyard-recipes", :group => "development"

after_bundler do
  `bundle exec ey-recipes init --on-deploy`
end


__END__

name: Recipes on Deploy
description: Run Engine Yard Cloud recipes during deployment instead of independently.
author: drnic
website: https://github.com/engineyard/engineyard-recipes

requires: [redis, eycloud_chef_on_deploy]
run_after: eycloud-recipes

category: deployment
tags: [background, worker]
exclusive: eycloud-recipes
