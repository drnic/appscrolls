gem 'fixture_builder', :group => [:test]
gem 'mocha', :group => [:test]

after_everything do

  create_file "spec/support/fixture_builder.rb", <<-RUBY
FixtureBuilder.configure do |fbuilder|
  # rebuild fixtures automatically when these files change:
  fbuilder.files_to_check += Dir["spec/factories/*.rb", "spec/support/fixture_builder.rb"]

  # now declare objects
  fbuilder.factory do

  end
end   
RUBY

inject_into_file "spec/spec_helper.rb", :after => "require 'rspec/rails'\n" do
  "require 'spec/support/fixture_builder.rb'\n"
end

gsub_file "spec/spec_helper.rb", "config.mock_with :rspec", "# config.mock_with :rspec"
gsub_file "spec/spec_helper.rb", "# config.mock_with :mocha", "  config.mock_with :mocha"

end

__END__

name: FixtureBuilder
description: "Allows you to build file fixtures from an object mother factory."
author: lightyrs

category: testing
run_after: [rspec]
requires: [rspec]