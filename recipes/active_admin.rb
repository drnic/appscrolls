#unless recipes.include? 'sass-rails'
#  gem 'sass-rails'
#end
gem 'activeadmin'

after_everything do
  generate "active_admin:install"
end

__END__

name: active_admin
description: "Add Active Admin for administration style interfaces"
author: jonochang

exclusive: administration_framework
category: administration
tags: [administration]
