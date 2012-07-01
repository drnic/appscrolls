gem 'devise'

inject_into_file 'config/environments/development.rb', "\n  config.action_mailer.default_url_options = { :host => 'localhost', :port => 3000 }\n", :after => "Application.configure do"
inject_into_file 'config/environments/test.rb',        "\n  config.action_mailer.default_url_options = { :host => 'localhost', :port => 3000 }\n", :after => "Application.configure do"
inject_into_file 'config/environments/production.rb',  "\n  config.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n", :after => "Application.configure do"

if scrolls.include? 'heroku'
  inject_into_file 'config/application.rb', "\n    # Force application to not access DB or load models when precompiling your assets (Devise+heroku recommended)\n    config.assets.initialize_on_precompile = false\n", :after => "class Application < Rails::Application"
end

unless scrolls.include? 'rails_basics'
  route "root :to => 'home#index'"
end

after_bundler do
  generate 'devise:install' unless scrolls.include? 'active_admin'

  if scrolls.include? 'mongo_mapper'
    gem 'mm-devise'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/', 'devise/orm/mongo_mapper_active_model'
    generate 'mongo_mapper:devise User'
  elsif scrolls.include? 'mongoid'
    gsub_file 'config/initializers/devise.rb', 'devise/orm/active_record', 'devise/orm/mongoid'
  end      

  generate 'devise user'
  generate 'devise:views'

end

__END__

name: Devise
description: Utilize Devise for authentication, automatically configured for your selected ORM.
author: mbleigh

category: authentication
exclusive: authentication
run_after: active_admin