gem 'devise'


after_bundler do
  generate "devise:install"

  if config['scoped_views']
    gsub_file "config/initializers/devise.rb", /# config\.scoped_views = false/, 'config.scoped_views = true'

    config['resources'].split.each do |resource|
      generate "devise #{resource}"
      generate "devise:views #{resource}"
    end
  else
    generate "devise #{config['resource']}"
    generate "devise:views #{config['resource']}"
  end
end

after_everything do
  inject_into_file 'config/environments/development.rb', "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }\n", :after => "Application.configure do"
  inject_into_file 'config/environments/test.rb',        "\nconfig.action_mailer.default_url_options = { :host => 'localhost:7000' }\n", :after => "Application.configure do"
  inject_into_file 'config/environments/production.rb',  "\nconfig.action_mailer.default_url_options = { :host => '#{@name}.com' }\n", :after => "Application.configure do"

  inject_into_file 'config/routes.rb', "\n  root :to => 'home#index'\n", :after => "#{@name}::Application.routes.draw do"
end

__END__

name: Devise
description: "Flexible authentication solution for Rails with Warden."
author: fractaloop

category: authentication

config:
  - scoped_views:
      type: boolean
      prompt: "Is there more than 1 Devise resource?"
  - resources:
      type: string
      prompt: "List all the resources separated by spaces:"
      if: scoped_views
  - resource:
      type: string
      prompt: "What is the Devise model named?"
      unless: scoped_views