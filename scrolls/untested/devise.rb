gem 'devise'

inject_into_file 'config/environments/development.rb', "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }\n", :after => "Application.configure do"
inject_into_file 'config/environments/test.rb',        "\nconfig.action_mailer.default_url_options = { :host => 'localhost:7000' }\n", :after => "Application.configure do"
inject_into_file 'config/environments/production.rb',  "\nconfig.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n", :after => "Application.configure do"

inject_into_file 'config/routes.rb', "\nroot :to => 'home#index'\n", :after => "Testapp::Application.routes.draw do"

after_bundler do
  generate 'devise:install'

  if scrolls.include? 'mongo_mapper'
    gem 'mm-devise'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
    generate 'mongo_mapper:devise User'
  elsif scrolls.include? 'mongoid'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
  end      

  generate 'devise user'
  generate "devise:views"

  if config['add_app_helpers']
    new_helpers = <<-RB
module ApplicationHelper

  def current_user
    @current_user
  end

  def logged_in?
    @current_user != nil
  end
RB
    gsub_file 'app/helpers/application_helper.rb', 'module ApplicationHelper', new_helpers
  end
end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: mbleigh

category: authentication
exclusive: authentication

config:
  - add_app_helpers:
      type: boolean
      prompt: "Add logged_in and current_user helpers?"

