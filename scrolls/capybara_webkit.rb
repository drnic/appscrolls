gem_group :test do
  gem 'capybara-webkit'
  if config['headless_ci']
    gem 'headless'
  end
end

after_bundler do
  # Capybara.javascript_driver = :webkit
end

__END__

name: Capybara Webkit
description:
author: drnic
website: https://github.com/thoughtbot/capybara-webkit

requires: [capybara]
run_after: [capybara]
run_before: []

category: testing
# exclusive:

config:
  - headless_ci:
      type: boolean
      prompt: "Headless mode for CI testing?"
