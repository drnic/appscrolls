gem_group :assets do
  gem 'twitter-bootstrap-rails'
end

after_bundler do
  generate "bootstrap:install"
  layout = config["twitter_bootstrap_layout"]
  generate "bootstrap:layout application #{layout} -f"  
end

__END__

name: Twitter Bootstrap Rails
description: Add Twitter Bootstrap CSS

category: stylesheet
exclusive: stylesheet
tags: [css, stylesheet]

config:
  - twitter_bootstrap_layout:
      prompt: "Which Twitter Bootstrap layout?"
      type: multiple_choice
      choices: [["Fluid", "fluid"], ["Fixed", "fixed"]]


