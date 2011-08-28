gem 'factory_girl_rails', :group => [:development, :test]
gem 'rails3-generators', :group => [:development, :test]

inject_into_file "config/initializers/generators.rb", :after => "Rails.application.config.generators do |g|\n" do
  "    g.fixture_replacement :factory_girl, :dir => \"spec/factories\"\n"
end

__END__

name: Factory Girl
description: "Use Factory Girl to replace fixtures with factories."
author: fabn

exclusive: factories
category: testing
run_after: [rspec]
requires: [rspec]
tags: [fixtures,factories]