# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.dirname(__FILE__) + "/version"

Gem::Specification.new do |s|
  s.name        = "ey_rails_wizard"
  s.version     = RailsWizard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Bleigh", "Dr Nic Williams"]
  s.email       = ["michael@intridea.com", "drnicwilliams@gmail.com"]
  s.homepage    = "http://railswizard.engineyard.com/"
  s.summary     = %q{A tool for quickly generating Rails applications for Engine Yard Cloud.}
  s.description = %q{Quickly and easily create Rails application templates featuring dozens of popular libraries tuned for Engine Yard Cloud}

  s.add_dependency "i18n"
  s.add_dependency "activesupport", "~> 3.0"
  s.add_dependency "thor"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "bundler", "~> 1.1.0"
  s.add_development_dependency "rails", ">= 3.0.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

