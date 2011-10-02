
after_bundler do
  run 'rails plugin install git://github.com/parolkar/pfeed.git'

  run 'rake pfeed:setup'
end

__END__

name: pFeed
description: "Plugin to create a user's activity feed"
author: jonochang

category: social-networking
exclusive: social-networking

