gem 'ffaker', :group => [:development, :test]

inject_into_file "spec/spec_helper.rb", :after => "require 'rspec/rails'\n" do
  "require 'ffaker'\n"
end

__END__

name: ffaker
description: "Fast Faker == Faker refactored."
author: lightyrs

category: testing
run_after: [rspec]
requires: [rspec]