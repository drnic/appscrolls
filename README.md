# The Eldar Scrolls for App Transformations

The Eldar Scrolls is a magical tool to generate new Rails and modify existing Rails applications (coming) to include your favourite, powerful magic. Authentication, testing, persistence, javascript, css, deployment, and templating - there's a magical scroll for you.

## Installation

Installation is simple:

    gem install eldar

## Usage

The primary usage of the `eldar` gem is to utilize its interactive terminal command to build a Rails template. To get started, you can simply run the command thusly:

    eldar new APP_NAME

Where `APP_NAME` is the directory in which you wish to create the app (it mirrors the Rails creation syntax). You will then be guided through the scroll selection process and subsequently the Rails app generator will automatically run with the template and all appropriate command line options included.

### Specifying Scrolls

If you wish to skip the interactive scroll selector, you may provide instead a list of scrolls with the `-r` option:

    eldar new APP_NAME -r jquery mongo_mapper sass

This will automatically generate a Rails template with the provided scrolls and begin the app generator.

### Listing Scrolls

You can also print out a simple list of scrolls:

    eldar list

Or print out a list of scrolls for a specific category:

    eldar list persistence

## Deployment Support

### Engine Yard

If you choose the `eycloud` scroll, your application will be automatically deployed to Engine Yard Cloud. Your code will also be automatically stored on a private/public GitHub repository.

The `eycloud` scroll magically transforms many other scrolls to work specifically for Engine Yard Cloud. For example:

* `postgresql` - the environment will have PostgreSQL selected instead of MySQL
* `resque` - the environment will have Resque and Redis

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

## History

## License

Engine Yard Rails Wizard and its scrolls are distributed under the MIT License.

[1]:http://railswizard.engineyard.com/
[2]:https://github.com/engineyard/eldar/tree/master/scrolls
[3]:https://github.com/engineyard/eldar.web
[4]:https://github.com/intridea/eldar
