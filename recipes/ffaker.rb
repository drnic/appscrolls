gem 'ffaker', :group => [:development, :test]

after_everything do
  inject_into_file "spec/spec_helper.rb", :after => "require 'rspec/rails'\n" do
    "require 'ffaker'\n"
  end
end

__END__

name: ffaker
description: "Fast Faker == Faker refactored."
author: lightyrs

requires: [rspec]
run_after: [rspec]
category: testing