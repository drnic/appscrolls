gem 'puma'

after_bundler do
  gsub_file "config/environments/production.rb", "# config.threadsafe!", "config.threadsafe!"

  gsub_file "script/rails", "require 'rails/commands'", <<-RUBY

require 'rack/handler'
Rack::Handler::WEBrick = Rack::Handler.get(:puma)

require 'rails/commands'
RUBY
end

__END__

name: Puma
description: Ruby web server built for speed & concurrency
author: drnic
website: http://puma.io

category: deployment
exclusive: appserver
