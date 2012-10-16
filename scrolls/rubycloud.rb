before_everything do
  # remove commented lines and multiple blank lines from Gemfile
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"

  # remove commented lines and multiple blank lines from config/routes.rb
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"

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

requires: [git, heroku, rbenv, rails_basics, less, postgresql]
run_after: []
run_before: []

category: other

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
