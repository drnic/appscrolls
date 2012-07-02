require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

append_file 'Gemfile', "\nguard_notifications = #{config['guard_notifications'].inspect}\n"

case HOST_OS
when /darwin/i
  gem 'rb-fsevent', :group => :development
  append_file 'Gemfile', "\ngem 'ruby_gntp', :group => :development if guard_notifications\n"
when /linux/i
  gem 'libnotify', :group => :development
  gem 'rb-inotify', :group => :development
when /mswin|windows/i
  gem 'rb-fchange', :group => :development
  gem 'win32console', :group => :development
  append_file 'Gemfile', "\ngem 'rb-notifu' if guard_notifications\n"
end


# LiveReload

application nil, :env => "development" do
  "config.middleware.insert_before(Rack::Lock, Rack::LiveReload)"
end

gem_group :development do
  gem 'guard-livereload'
  gem 'yajl-ruby'
  gem 'rack-livereload'

# Guard for other Scrolls

  gem 'guard-bundler'
  gem 'guard-test' if scrolls.include? 'test_unit'

  KNOWN_GUARD_SCROLLS = %w[cucumber haml less passenger puma redis resque rspec spork unicorn]
  KNOWN_GUARD_SCROLLS.each do |scroll|
    gem "guard-#{scroll}" if scrolls.include? scroll
  end
end

after_bundler do
  run "bundle exec guard init"
  
  # TODO move livereload to the top of the Guardfile so it is zippy quick
end


__END__

name: Guard
description: Command line tool to file system modification events; Powers Up with other scrolls!
author: drnic
website: https://github.com/guard/guard

requires: []
run_after: []
run_before: []

category: other
# exclusive: 

config:
  - guard_notifications:
      type: boolean
      prompt: "Enable desktop Guard/Growl notifications?"
