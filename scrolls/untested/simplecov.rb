gem 'simplecov', :require => false, :group => [:development, :test]

after_bundler do
  if scroll? "test_unit"
    prepend_file "test/test_helper.rb", <<-RUBY
    require 'simplecov'
    SimpleCov.start 'rails'
    RUBY
  end

  if scroll? "rspec"
    prepend_file "spec/spec_helper.rb", <<-RUBY
    require 'simplecov'
    SimpleCov.start 'rails'
    RUBY
  end

  # if scroll? "cucumber"
  #   prepend_file "features/support/env.rb", <<-RUBY
  #   require 'simplecov'
  #   SimpleCov.start 'rails'
  #   RUBY
  # end
end

__END__

name: SimpleCov
description: Code coverage for Ruby 1.9
author: jaimie-van-santen

exclusive: code_coverage
category: testing
tags: [code_coverage, testing]

requires:
run_after: [rspec, test_unit, cucumber]