gem_group :development do
  gem 'guard', '>= 0.6.2', :group => :development
end


prepend_file 'Gemfile' do <<-RUBY
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

RUBY
end

append_file 'Gemfile' do <<-RUBY

case HOST_OS
when /darwin/i
  gem 'rb-fsevent', :group => :development
  gem 'growl_notify', :group => :development
when /linux/i
  gem 'libnotify', :group => :development
  gem 'rb-inotify', :group => :development
when /mswin|windows/i
  gem 'rb-fchange', :group => :development
  gem 'win32console', :group => :development
  gem 'rb-notifu', :group => :development
end

RUBY

def guards
  @guards ||= []
end

def guard(name, version = nil)
  args = []
  if version
    args << version
  end
  
  gem_group :development do
    gem "guard-#{name}", *args
  end
  
  guards << name
end

guard 'bundler'

KNOWN_GUARD_SCROLLS = %w[cucumber haml less passenger puma redis resque rspec unicorn]
KNOWN_GUARD_SCROLLS.each do |scroll|
  if recipes.include? scroll
    guard scroll
  end
end

if recipes.include? 'test_unit'
  guard 'test'
end

after_bundler do
  run 'guard init'
  guards.each do |name|
    run "guard init #{name}"
  end
end


__END__

name: Guard
description: 
author: drnic
website:

requires: []
run_after: []
run_before: []

category: other # authentication, testing, persistence, javascript, css, services, deployment, and templating
# exclusive: 

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
