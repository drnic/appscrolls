gem 'guard', '>= 0.6.2', :group => :development

prepend_file 'Gemfile' do <<-RUBY
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

RUBY
end

append_file 'Gemfile' do <<-RUBY

case HOST_OS
when /darwin/i
  gem 'rb-fsevent', :group => :development
when /linux/i
  gem 'libnotify', :group => :development
  gem 'rb-inotify', :group => :development
when /mswin|windows/i
  gem 'rb-fchange', :group => :development
  gem 'win32console', :group => :development
  gem 'rb-notifu', :group => :development
end

RUBY
end

# LiveReload

gem 'guard-livereload'
gem_group :development do
  gem 'yajl-ruby'
  gem 'rack-livereload'
end

application nil, :env => "development" do
  "config.middleware.insert_before(Rack::Lock, Rack::LiveReload)"
end

# Guard for other Scrolls

gem 'guard-bundler'

gem 'guard-test' if scrolls.include? 'test_unit'

KNOWN_GUARD_SCROLLS = %w[cucumber haml less passenger puma redis resque rspec unicorn]
KNOWN_GUARD_SCROLLS.each do |scroll|
  gem "guard-#{scroll}" if scrolls.include? scroll
end

after_bundler do
  run "bundle exec guard init"
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

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
