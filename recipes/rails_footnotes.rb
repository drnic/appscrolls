gem 'rails-footnotes', '>= 3.7.5.rc4', :group => :development

after_bundler do
  generate 'rails_footnotes:install'
end

__END__

name: Rails Footnotes
description: Displays footnotes in your application for easy debugging, such as sessions, request parameters, cookies, filter chain, routes, queries, etc 

category: rails-instrumentation
exclusive: rails-instrumentation
tags: [rails-instrumentation]

