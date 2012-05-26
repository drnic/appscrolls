gem 'haml', '>= 3.0.0'
gem 'haml-rails'

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.template_engine :haml\n"
end

after_bundler do
  create_file "app/views/layouts/application.html.haml", <<-RUBY
!!!
%html
  %head
    %title Application
    = stylesheet_link_tag :application
    = javascript_include_tag :application
    = csrf_meta_tag
  %body
    = yield
RUBY
end

__END__

name: HAML
description: "Utilize HAML for templating."
author: axy

category: templating
exclusive: templating
