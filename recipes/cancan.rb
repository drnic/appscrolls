gem 'cancan'

after_bundler do
  bundle exec rake "db:migrate"
  generate "cancan:ability"
end

__END__

name: Cancan
description: "Utilize Cancan for authorization."
author: amolk

category: authentication
exclusive: authorization