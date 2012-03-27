# Engine Yard Rails Wizard Gem 

The Engine Yard RailsWizard gem is both the official repository of scrolls for [Engine Yard RailsWizard][1] as well as a stand-alone tool to generate rails templates from the command line. The website and the gem are kept in version sync, so any scrolls released to the gem will be simultaneously available on the web builder.

This is a fork of the original [RailsWizard gem][4] specifically for Engine Yard Cloud customers. We are very thankful to Michael Bleigh and Intridea for creating Rails Wizard.

Generated applications may include EY Cloud scrolls to setup/run required services.

## Installation

Installation is simple:

    gem install ey_rails_wizard

## Usage

The primary usage of the `ey_rails_wizard` gem is to utilize its interactive terminal command to build a Rails template. To get started, you can simply run the command thusly:

    ey_rails_wizard new APP_NAME

Where `APP_NAME` is the directory in which you wish to create the app (it mirrors the Rails creation syntax). You will then be guided through the scroll selection process and subsequently the Rails app generator will automatically run with the template and all appropriate command line options included.

### Specifying Scrolls

If you wish to skip the interactive scroll selector, you may provide instead a list of scrolls with the `-r` option:

    ey_rails_wizard new APP_NAME -r jquery mongo_mapper sass

This will automatically generate a Rails template with the provided scrolls and begin the app generator.

### Listing Scrolls

You can also print out a simple list of scrolls:

    ey_rails_wizard list

Or print out a list of scrolls for a specific category:

    ey_rails_wizard list persistence

# EY Rails Wizard Scrolls

The Engine Yard Rails Wizard scroll collection now live in this GitHub repository to make them fork-friendly and available for use with the command-line tool. You can see all of the scrolls in the [scrolls directory][2].

If you're looking for the web app source code, it now lives at [ey_rails_wizard.web][3].

## Submitting a Scroll

Create new scrolls using:

    rake new NAME=scroll-name

Submitting a scroll is actually a very straightforward process. Scrolls are made of up **template code** and **YAML back-matter** stored in a ruby file. The `__END__` parsing convention is used so that each scroll is actually a valid, parseable Ruby file. The structure of a scroll looks something like this:

```ruby
gem 'supergem'

after_bundler do
  generate "supergem:install"
end

__END__

category: templating
name: SuperGem
description: Installs SuperGem which is useful for things
author: mbleigh
```

It's really that simple. The gem has RSpec tests that automatically validate each scroll in the repository, so you should run `rake spec` as a basic sanity check before submitting a pull request. Note that these don't verify that your scroll code itself works, just that Engine Yard Rails Wizard could properly parse and understand your scroll file.

For more information on all available options for authoring scrolls,
please see the 

## License

Engine Yard Rails Wizard and its scrolls are distributed under the MIT License.

[1]:http://railswizard.engineyard.com/
[2]:https://github.com/engineyard/ey_rails_wizard/tree/master/scrolls
[3]:https://github.com/engineyard/ey_rails_wizard.web
[4]:https://github.com/intridea/rails_wizard
