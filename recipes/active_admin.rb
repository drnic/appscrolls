gem 'rails_admin', :git => 'git://github.com/gregbell/active_admin.git'

after_bundler do
  generate 'active_admin:install'
end

__END__

name: ActiveAdmin
description: "Install ActiveAdmin to manage data in your application"
author: porta

category: other
