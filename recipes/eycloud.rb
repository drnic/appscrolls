gem 'engineyard'
gem 'ey_config'

after_bundler do
  create_file "EngineYardCloud.md", <<-README
# Using Engine Yard Cloud

## Initial Deployment

* Host this git repository (such as on [GitHub](https://github.com))
* From the [Dashboard](https://cloud.engineyard.com/), click "New an Application"
* Add the "Git Repository URI"
* Click "Create Application"
* Add an Environment Name
* Click "Create Environment"
* Click "Boot this Configuration"

README

end

__END__

name: Engine Yard Cloud
description: The Most Powerful Ruby Cloud
author: drnic

requires: [git]
category: deployment
exclusive: deployment
