gem 'cucumber-rails', :group => [:development, :test]
gem 'capybara', :group => [:development, :test]
gem 'database_cleaner', :group => [:development, :test]

after_bundler do
  generate "cucumber:install --capybara#{' --rspec' if scrolls.include?('rspec')}#{' -D' unless scrolls.include?('activerecord')}"
end

__END__

name: Cucumber
description: "Use Cucumber for integration testing with Capybara."
author: mbleigh

exclusive: acceptance_testing 
category: testing
tags: [acceptance]
