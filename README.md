# The App Scrolls for creating and transforming Rails apps

```
             ___               ____             ____  
            / _ | ___  ___    / __/__________  / / /__
           / __ |/ _ \/ _ \  _\ \/ __/ __/ _ \/ / (_-<
          /_/ |_/ .__/ .__/ /___/\__/_/  \___/_/_/___/
               /_/  /_/                               
```

The App Scrolls is a magical tool to generate new Rails and modify existing Rails applications (coming) to include your favourite, powerful magic. Authentication, testing, persistence, javascript, css, deployment, and templating - there's a magical scroll for you.

* Follow on twitter [@appscrolls][9]
* [![Build Status](https://secure.travis-ci.org/drnic/appscrolls.png?branch=master)](http://travis-ci.org/drnic/appscrolls)
* [![Dependency Status](https://gemnasium.com/drnic/appscrolls.png?branch=master)](https://gemnasium.com/drnic/appscrolls)

An example application that was built by the App Scrolls is at [https://github.com/drnic/mydemoapp][14]. The generated README shows all the scrolls that were included.

## Installation

Installation is simple:

    gem install appscrolls

## Usage

The primary usage of the `appscrolls` gem is to utilize its interactive terminal command to build a new Rails application. To get started, you can simply run the command thusly:

    appscrolls new APP_NAME
    scrolls new APP_NAME

Where `APP_NAME` is the directory in which you wish to create the app (it mirrors the Rails creation syntax). You will then be guided through the scroll selection process and subsequently the Rails app generator will automatically run with the template and all appropriate command line options included.

To transform an existing Rails app, you ... wait, that's not implemented yet. But since the "apply template" feature of `rails new APP_NAME -m template.rb` is implemented in Thor, I mean, how hard could it be?*

### Available Scrolls

The current available scrolls grouped by category:

* administration: active_admin, rails_admin
* assets: jquery, prototype
* deployment: eycloud, eycloud_recipes_on_deploy, git, github, passenger, thin, unicorn
* persistence: mysql, postgresql, redis, sqlite3
* stylesheet: twitter_bootstrap
* templating: simple_form
* testing: capybara, cucumber, rspec, test_unit
* worker: delayed_job, resque
* other: env_yaml, guard, rails_basics, split

### Specifying Scrolls

If you wish to skip the interactive scroll selector, you may provide instead a list of scrolls with the `-s` or `--scrolls` option:

    scrolls new APP_NAME -s twitter_bootstrap mysql resque
    scrolls new APP_NAME --scrolls postgresql github eycloud

This will automatically generate a Rails template with the provided scrolls and begin the app generator.

### Listing Scrolls

You can also print out a simple list of scrolls:

    scrolls list

Or print out a list of scrolls for a specific category:

    scrolls list persistence

### User Scrolls

You can define an environment variable APPSCROLLS_DIR with a path to your local app scrolls:

    export APPSCROLLS_DIR=~/.scrolls

### Scroll Configuration

If you wish to skip any configuration questions, you can provide the path to a configuration file with the `-c` or `--config` option:

    scrolls new APP_NAME -c ~/.scrolls_config.rb
    
This config file is a script that can provide defaults for any scrolls by setting @configs[SCROLL_NAME][OPTION_NAME].  For example:
```
@configs['postgresql']['pg_username'] = 'root'
@configs['postgresql']['pg_password'] = ''
@configs['guard']['guard_notifications'] = false
```


## Deployment Support

Web applications are boring if they aren't running proudly on the internet. The App Scrolls make this automatic for your favourite providers!

### Engine Yard

Scroll: `eycloud`

Example:

```
scrolls new mydemoapp -s twitter_bootstrap unicorn postgresql resque github eycloud
```

The created application above will be automatically stored in a git private/public repository on GitHub and then deployed to [Engine Yard Cloud][6].

When deploying to [Engine Yard Cloud][6] you will need to choose:

* `unicorn` or `passenger` for your app server
* `mysql` or `postgresql` for your SQL DB

When choosing from the following scrolls, your Engine Yard Cloud environment will be automatically upgraded/configured with Chef recipes. 

* `resque` - add utility instances called `resque` for workers [see [readme][15] for more information]
* `redis` - add a utility called `redis` to have a dedicated redis DB; else it is run on your DB master or Solo instance
* `delayed_job` - add utility instances called `delayed_job` or `dj` for workers [see [readme][16] for more information]

Note: Resque is recommended instead of Delayed Job. Soon, Sidekiq will be recommended over both, and 

Please open an Issue if you want an alternate option (`puma` or `thin`; or `mongodb`)

### Heroku

The App Scrolls needs a Heroku Master to support Heroku for the App Scrolls. 

There is some initial work in the [current scrolls][11] and the [archived/unsupported scrolls][12]

### CloudFoundry

The App Scrolls needs a CloudFoundry Master to support CloudFoundry for the App Scrolls. 

## Authoring Scrolls of Magical Mystery

Create new scrolls using:

    thor :new scroll-name

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

It's really that simple. The gem has RSpec tests that automatically validate each scroll in the repository, so you should run `rake spec` as a basic sanity check before submitting a pull request. Note that these don't verify that your scroll code itself works, just that App Scrolls could properly parse and understand your scroll file.

## History

This project is an old fashioned fork of [Michael Bleigh][5]'s [Rails Wizard][4]. A new name, new project, and new purpose. 

This project wouldn't exist without Michael having created [Rails Wizard][4] during Rails Rumble and maintaining and upgrading it for a long time. Sadly support dropped off, several recipes did not work with Rails 3.1+, 

[Dr Nic][7] originally worked on [Rails Wizard][4] to provide [Engine Yard Cloud][6] support, his employer and his favourite hosting platform. He also merged in a lot of recipes from other forks, and added new recipes for modern projects.

Support for Engine Yard Cloud meant integration with Chef Recipes. This meant confusing language - Rails Wizard Recipes and Chef Recipes. He decided that wizards don't use recipes - they use scrolls. Alchemists use recipes. And screw alchemists and their dinky potions. Recipes became Scrolls.

## Future

* Automatically setup Continuous Integration for new applications - branches "jenkins"
* Interactive mode is a wizard by categories "pick A, B, C or none"
* Apply scrolls to existing Rails applications - branch "[apply_scrolls][13]"*
* Scrolls work or fail fast on Heroku
* Scrolls work or fail fast on CloudFoundry
* Scrolls generate their own README - branch "readmes"
* 3rd party services/add-ons enabled within deployment platform or directly with service
* Padrino / Sinatra applications
* Non-Ruby applications (Lithium for PHP, etc)

Missing scrolls

* MongoDB - branch "mongodb"
* OmniAuth - branch "omniauth"
* Sidekiq - branch "sidekiq"

How hard could it be?

* `*` 'How hard could it be to transform applications?' - pretty hard. Scrolls need to be aware of the current code base, rather than merely the list of other scrolls being used to create a new app. Scrolls also need to know about versions of Rails rather than just latest rails.

## Thanks

ASCII banner - http://www.network-science.de/ascii/ using 'smslant' font.

## License

App Scrolls and its scrolls are distributed under the MIT License. See [MIT_LICENSE][10] for the actual words.

[1]:http://appscrolls.org/
[2]:https://github.com/drnic/appscrolls
[2]:https://github.com/drnic/appscrolls/tree/master/scrolls
[4]:https://github.com/intridea/rails_wizard
[5]:https://github.com/mbleigh
[6]:http://www.engineyard.com/products/cloud
[7]:http://drnicwilliams.com
[9]:https://twitter.com/appscrolls
[10]:https://github.com/drnic/appscrolls/blob/master/MIT_LICENSE
[11]:https://github.com/drnic/appscrolls/tree/master/scrolls
[12]:https://github.com/drnic/appscrolls/tree/master/scrolls/zzz
[13]:https://github.com/drnic/appscrolls/tree/apply_scrolls
[14]:https://github.com/drnic/mydemoapp
[15]:https://github.com/engineyard/eycloud-recipe-resque#readme
[16]:https://github.com/engineyard/eycloud-recipe-delayed_job#readme
