gem 'activeadmin'

after_bundler do
  generate "active_admin:install"
  inject_into_file "config/application.rb", "\n    config.assets.precompile += ['active_admin.js', 'active_admin.css']", :before => "\n  end"
end

__END__

name: Active Admin
description: "The administration framework for Ruby on Rails applications"
author: jonochang
website: http://activeadmin.info/

exclusive: administration
category: administration
tags: [administration]
