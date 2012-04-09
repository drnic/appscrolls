# The Eldar Scrolls for App Transformations

```
   ______   __           ____             ____  
  / __/ /__/ /__ _____  / __/__________  / / /__
 / _// / _  / _ `/ __/ _\ \/ __/ __/ _ \/ / (_-<
/___/_/\_,_/\_,_/_/   /___/\__/_/  \___/_/_/___/
```

The Eldar Scrolls is a magical tool to generate new Rails and modify existing Rails applications (coming) to include your favourite, powerful magic. Authentication, testing, persistence, javascript, css, deployment, and templating - there's a magical scroll for you.

## Installation

Installation is simple:

    gem install eldarscrolls

## Usage

The primary usage of the `eldarscrolls` gem is to utilize its interactive terminal command to build a new Rails application. To get started, you can simply run the command thusly:

    eldarscrolls new APP_NAME

Where `APP_NAME` is the directory in which you wish to create the app (it mirrors the Rails creation syntax). You will then be guided through the scroll selection process and subsequently the Rails app generator will automatically run with the template and all appropriate command line options included.

### Specifying Scrolls

If you wish to skip the interactive scroll selector, you may provide instead a list of scrolls with the `-s` or `--scrolls` option:

    eldarscrolls new APP_NAME -s twitter_bootstrap mysql resque
    eldarscrolls new APP_NAME --scrolls postgresql github eycloud

This will automatically generate a Rails template with the provided scrolls and begin the app generator.

### Listing Scrolls

You can also print out a simple list of scrolls:

    eldarscrolls list

Or print out a list of scrolls for a specific category:

    eldarscrolls list persistence

## Deployment Support

Web applications are boring if they aren't running proudly on the internet. The Eldar Scrolls make this automatic for your favourite providers!

### Engine Yard

Scroll: `eycloud`

If you choose the `eycloud` scroll, your application will be automatically deployed to [Engine Yard Cloud][6]. Your code will also be automatically stored on a private/public GitHub repository.

The `eycloud` scroll magically transforms many other scrolls to work specifically for [Engine Yard Cloud][6]. For example:

* `postgresql` - the environment will have PostgreSQL selected instead of MySQL
* `resque` - the environment will have Resque and Redis

### Heroku

The Eldar Scrolls needs a Heroku Master to support Heroku for the Eldar Scrolls. 

There is some initial work in the [current scrolls][11] and the [archived/unsupported scrolls][12]

### CloudFoundry

The Eldar Scrolls needs a CloudFoundry Master to support CloudFoundry for the Eldar Scrolls. 

## Authoring Scrolls of Magical Mystery

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

It's really that simple. The gem has RSpec tests that automatically validate each scroll in the repository, so you should run `rake spec` as a basic sanity check before submitting a pull request. Note that these don't verify that your scroll code itself works, just that Eldar Scrolls could properly parse and understand your scroll file.

## History

This project is an old fashioned fork of [Michael Bleigh][5]'s [Rails Wizard][4]. A new name, new project, and new purpose. 

This project wouldn't exist without Michael having created [Rails Wizard][4] during Rails Rumble and maintaining and upgrading it for a long time. Sadly support dropped off, several recipes did not work with Rails 3.1+, 

[Dr Nic][7] originally worked on [Rails Wizard][4] to provide [Engine Yard Cloud][6] support, his employer and his favourite hosting platform. He also merged in a lot of recipes from other forks, and added new recipes for modern projects.

Support for Engine Yard Cloud meant integration with Chef Recipes. This meant confusing language - Rails Wizard Recipes and Chef Recipes. He decided that wizards don't use recipes - they use scrolls. Alchemists use recipes. And screw alchemists and their dinky potions. Recipes became Scrolls.

"Eldar Scrolls" is a deliberate misspelling of the popular [Elder Scrolls][8] computer game. Ok, it was accidental but "eldarscrolls" and "eldarscrolls" should now be much easier to search for on Twitter and Google; and [@eldarscrolls][9] [eldarscrolls.org][1] were available

## Thanks

ASCII banner - http://www.network-science.de/ascii/ using 'smslant' font.

## License

Eldar Scrolls and its scrolls are distributed under the MIT License.

[1]:http://eldarscrolls.org/
[2]:https://github.com/drnic/eldarscrolls
[2]:https://github.com/drnic/eldarscrolls/tree/master/scrolls
[4]:https://github.com/intridea/rails_wizard
[5]:https://github.com/mbleigh
[6]:http://www.engineyard.com/products/cloud
[7]:http://drnicwilliams.com
[8]:http://www.elderscrolls.com/
[9]:https://twitter.com/elderscrolls
[11]:https://github.com/drnic/eldarscrolls/tree/master/scrolls
[12]:https://github.com/drnic/eldarscrolls/tree/master/scrolls/zzz
