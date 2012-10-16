before_everything do
  # Remove comments from rails generated files
  remove_comments_and_blank_lines 'Gemfile'
  remove_comments_and_blank_lines 'config/routes.rb'
  remove_comments_and_blank_lines 'config/database.yml'
  remove_comments_and_blank_lines '.gitignore'

  # turn off coffeescript
  comment_lines 'Gemfile', "gem 'coffee-rails'"
end

after_bundler do
  insert_into_application_config <<-CONFIG
    # Use UTC for timestamps
    config.active_record.default_timezone = :utc
  CONFIG
end

after_everything do
end

__END__

name: RubyCloud
description: Favorite bundle of customizations for RubyCloud client apps
website: http://rubycloud.com
author: mattolson

requires: [git, heroku, rbenv, rails_basics, less, postgresql, services]
run_after: []
run_before: []

category: other

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
