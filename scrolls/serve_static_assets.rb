gsub_file 'config/environments/production.rb',
  'config.serve_static_assets = false', 'config.serve_static_assets = true'

__END__

name: Serve static assets
description: Configure Rails to serve static assets in production. Useful for deployments that require the application to serve assets, such as Heroku and Shelly Cloud
author: grk

category: assets

run_before: [git]