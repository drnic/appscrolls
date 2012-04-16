gem 'rails_admin'

after_bundler do
  generate "rails_admin:install"
end

__END__

name: RailsAdmin
description: "An engine that provides an easy-to-use interface for managing your data"
website: https://github.com/sferik/rails_admin
author: sferik
exclusive: administration
category: administration
tags: [administration]
