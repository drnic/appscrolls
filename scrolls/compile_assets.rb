gsub_file 'config/environments/production.rb',
  'config.assets.compile = false', 'config.assets.compile = true'

__END__

name: Compile assets
description: "Configure Rails to compile assets in production. Use to skip the lengthy precompile process, and let the app compile assets when they're first requested. Useful for deployments where those assets are cached."
author: grk

category: assets

run_before: [git]