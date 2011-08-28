gem 'activeadmin'

if Rails::VERSION::STRING.to_f >= 3.1
  gem 'sass-rails',     '~> 3.1.0.rc'
  gem "meta_search",    '>= 1.1.0.pre'
end

after_bundler do
  generate 'active_admin:install'
end

__END__

name: ActiveAdmin
description: "Install ActiveAdmin to manage data in your application"
author: porta

category: other