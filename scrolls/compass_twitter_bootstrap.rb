gem 'compass_twitter_bootstrap', :group => :assets

create_file "config/compass.rb", <<-END
# Require any additional compass plugins here.
project_type = :rails
END

layout = config["layout"]

after_everything do
  append_file "app/assets/stylesheets/application.css.scss", <<-END
@import "bootstrap_and_overrides";
END

  create_file "app/assets/stylesheets/_bootstrap_variables.css.scss", <<-END
// Variables to customize the look and feel of Bootstrap
// Override any variables from Bootstrap in this file
END

  create_file "app/assets/stylesheets/_bootstrap_and_overrides.css.scss", <<-END
@import "bootstrap_variables";
@import "compass_twitter_bootstrap_awesome";
@import "#{layout}"
END

  gsub_file "app/assets/javascripts/application.js", "//= require_tree .", <<-END
//= require bootstrap-all
//= require_tree .
END
end


  run "ln -s `bundle show compass_twitter_bootstrap`/stylesheets app/assets/stylesheets/bootstrap"
  append_file ".gitignore", "\napp/assets/stylesheets/bootstrap" if scrolls.include? 'git'
  
__END__

name: Compass Twitter Bootstrap Rails (Sass)
description: Add Twitter Bootstrap CSS in Sass via Compass

category: assets
exclusive: stylesheet
tags: [css, stylesheet]

requires: [compass]

config:
  - layout:
      prompt: "Responsive layout?"
      type: multiple_choice
      choices: [["Normal", "compass_twitter_bootstrap"], ["Responsive", "compass_twitter_bootstrap_responsive"]]

