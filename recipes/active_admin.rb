#unless recipes.include? 'sass-rails'
#  gem 'sass-rails'
#end
gem 'activeadmin'

after_everything do
  generate "active_admin:install"
end

__END__

name: Active Admin
description: "The administration framework for Ruby on Rails applications"
author: jonochang

exclusive: administration_framework
category: administration
tags: [administration]
