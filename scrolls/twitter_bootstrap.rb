gem_group :assets do
  gem 'twitter-bootstrap-rails'
end

after_bundler do
  generate "bootstrap:install"
  layout = config["twitter_bootstrap_layout"]
  generate "bootstrap:layout #{layout}"
  gsub_file "app/controllers/application_controller.rb", /class ApplicationController < ActionController::Base/, <<-RUBY
class ApplicationController < ActionController::Base
  layout "#{layout}"
RUBY
  
end

__END__

name: Twitter Bootstrap Rails
description: Add Twitter Bootstrap CSS

category: stylesheet
exclusive: stylesheet
tags: [css, stylesheet]

config:
  - twitter_bootstrap_layout:
      type: multiple_choice
      prompt: "Which Twitter Bootstrap layout?"
      choices: [["Fluid", "fluid"], ["Fixed", "fixed"]]


