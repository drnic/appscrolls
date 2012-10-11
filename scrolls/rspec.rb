gem 'rspec-rails', :group => [:development, :test]

after_bundler do
  gsub_file "config/initializers/generators.rb", /test_framework :test_unit.*\n/, "test_framework = :rspec\n"
  generate 'rspec:install'
end

__END__

name: RSpec
description: "Use RSpec for unit testing for this Rails app."
author: mbleigh

exclusive: unit_testing
category: testing

args: ["-T"]

