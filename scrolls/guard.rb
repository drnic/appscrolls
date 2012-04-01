prepend_file 'Gemfile' do <<-RUBY
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

RUBY
end

append_file 'Gemfile' do <<-RUBY

guard_notifications = #{config['guard_notifications'].inspect}
group :development do
  case HOST_OS
  when /darwin/i
    gem 'rb-fsevent'
    gem 'ruby_gntp' if guard_notifications
  when /linux/i
    gem 'libnotify'
    gem 'rb-inotify'
  when /mswin|windows/i
    gem 'rb-fchange'
    gem 'win32console'
    gem 'rb-notifu' if guard_notifications
  end
end
RUBY
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
