gem 'rails-footnotes', :group => :development

after_bundler do
  generate 'rails_footnotes:install'
end

__END__

name: Rails Footnotes
description: Displays footnotes in your application for easy debugging, such as sessions, request parameters, cookies, filter chain, routes, queries, etc 

category: other
tags: [debugging]

