gem 'ffaker'

after_bundler do
  # TODO - necessary to add this? or will bundler do it?
  inject_into_file "spec/spec_helper.rb", :after => "require 'rspec/rails'\n" do
    "require 'ffaker'\n"
  end
end

__END__

name: ffaker
description: "Fast Faker: Faker refactored for speed"
author: lightyrs

 # necessary?
requires: [rspec]
run_after: [rspec]

category: testing
exclusive: fake-data
tags: [fake-data]
