# FIXME recipe failing due to https://github.com/assaf/vanity/issues/105

gem 'vanity'

after_bundler do
  generate "vanity"
  rake "db:migrate"
  
  inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
    "  use_vanity :current_user\n"
  end
end

after_everything do
  
end

__END__

name: Vanity
description: Experiment Driven Development
website: http://vanity.labnotes.org/
author: drnic

requires: []
run_after: []
run_before: []

category: other
exclusive: ab-testing

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
