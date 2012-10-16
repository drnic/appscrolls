after_bundler do
  insert_into_application_config <<-CONFIG
    # Don't fully initialize app on precompilation (Heroku needs this)
    config.assets.initialize_on_precompile = false

    # Add optional components to asset precompilation. Anything not included in
    # application.js and application.css needs to be added here to ensure compilation
    # on deploy.
    # config.less.paths << ""
    config.assets.precompile += []
  CONFIG

  # Add push script
  create_file "script/push", <<-PUSH
#!/bin/bash
#
# Use this to precompile assets and deploy to heroku.
#

RAILS_ENV=production bundle exec rake assets:precompile
git add public
git commit -m "Precompile assets prior to deploy"
git push heroku master
  PUSH
  chmod "script/push", 0755
end

after_everything do

end

__END__

name: Heroku
description: Use heroku for deployment
website: http://www.heroku.com
author: mattolson

category: deployment
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
