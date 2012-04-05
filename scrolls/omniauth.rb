strategy_gem = ""
while strategy_gem.size == 0
  strategy_gem = ask_wizard "Which rubygem contains the strategy you choose? (e.g. 'omniauth-github'; press ENTER to see all)"

  if strategy_gem.size == 0
    say_custom "omniauth", "Displaying all strategies"
    run "gem list --remote omniauth-"
  end
end

gem 'omniauth', '~> 1.0'
gem strategy_gem

if strategy_gem =~ /omniauth-(.*)(?:-provider)?/
  strategy = $1
else
  strategy = "unknown"
end

after_bundler do
  route "match '/auth/:provider/callback', :to => 'sessions#callback'"
  file 'app/controllers/sessions_controller.rb', <<-RUBY
class SessionsController < ApplicationController
  def callback
    auth # Do what you want with the auth hash!
  end

  def auth
    request.env['omniauth.auth']
  end
end
RUBY

  initializer "omniauth.rb", <<-RUBY
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :#{strategy}, ENV['#{strategy.upcase}_KEY']
end
RUBY

end

# TODO consult https://raw.github.com/RailsApps/rails3-application-templates/master/rails3-mongoid-omniauth-template.rb

after_everything do
  say_custom "omniauth", "NOTICE: Please consult the strategy for final instructions https://github.com/search?q=#{strategy}"
end

__END__

name: OmniAuth
description: "Install OmniAuth and a selected Strategy/Provider"
author: drnic

exclusive: authentication
category: authentication
