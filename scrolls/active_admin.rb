gem 'activeadmin'

after_bundler do
  generate "active_admin:install"
  inject_into_file "config/application.rb", "\n    config.assets.precompile += ['active_admin.js', 'active_admin.css']", :before => "\n  end"
  if scrolls.include? 'devise'
    apply_patch :devise
    if scrolls.include? 'omniauth'
      apply_patch :omniauth
    end
  end
end

__END__

name: Active Admin
description: "The administration framework for Ruby on Rails applications"
author: jonochang
website: http://activeadmin.info/

exclusive: administration
category: administration
tags: [administration]
run_after: [devise, omniauth]