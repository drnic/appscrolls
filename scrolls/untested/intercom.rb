# gem 'intercom-ruby', :group => [:development]  # for API communication
gem 'intercom-rails' # to generate the javascript in the layout


# during initial generation (after "rails new")
# signin to intercom.io, fetch token, or enter tokens
# create new intercom app and get metadata


after_bundler do
  generate %Q|intercom:install #{config["intercom_app_id"]}|
end

after_everything do
end


__END__

name: Intercom
description: Install intercom.io
author: drnic
website: http://intercom.io

requires: []
run_after: []
run_before: []

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive: 

config:
  - intercom_app_id:
      type: string
      prompt: "What is your Intercom app id for this new, fantastic app?"
