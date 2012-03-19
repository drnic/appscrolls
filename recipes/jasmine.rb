gem 'jasmine', :group => [:development, :test]

after_bundler do
  generate "jasmine:install"
end

__END__

category: testing
name: Jasmine
description: Install jasmine for javascript testing
author: jtarchie