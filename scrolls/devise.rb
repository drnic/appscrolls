gem 'devise'

after_bundler do
  # Setup mailer host for dev and test
  insert_into_application_config <<-CONFIG
    # Set host for urls generated inside mailers
    config.action_mailer.default_url_options = { :host => 'localhost:5000' }
  CONFIG

  # Setup mailer host for production
  insert_into_environment_config 'production', <<-CONFIG
  # Set host for urls generated inside mailers
  config.action_mailer.default_url_options = { :host => 'www.#{@app_name}.com' }
  CONFIG

  # Make sure there is a default route
  unless File.open('config/routes.rb', 'r') { |f| f.read } =~ /\nroot/
    route "root :to => 'home#index'"
  end
  
  # Finish devise installation and generate model
  generate 'devise:install'
  generate 'devise User'
  generate "devise:views"
end

__END__

name: Devise
description: Utilize Devise for authentication
author: mattolson

category: authentication
exclusive: authentication

#config:
#  - prod_host:
#      type: string
#      prompt: "What url are you going to use for production?"
