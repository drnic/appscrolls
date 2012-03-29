gem_group :test do
  gem 'cucumber-rails', :required => false # https://github.com/cucumber/cucumber-rails/issues/202
  gem 'capybara'
  gem 'database_cleaner'
end


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
