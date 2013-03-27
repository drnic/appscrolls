# ChangeLog

## v0.10

* `puma` - added basic support for Puma; also Cloud Foundry will use Puma automatically

## v0.9

* `Cloud Foundry` - added support for uploading to Cloud Foundry
* `github` - now uses `hub` project instead of `github` gem
* `postgresql` - database.yml includes "host: localhost" for each env

## v0.8

* `postgresql` - supported on `eycloud` (Currently PostgreSQL 9.1)
* `eycloud` - can boot clusters, in addition to solos
* `mysql` - always generates `sample.rake`
* bin/scrolls is short-form of bin/appscrolls
* `puma` & `thin` - moved into zzz archive until Puma is released on EY Cloud; or another supporting platform added
* `spork` - moved into zzz archive as part of simplification

### v0.8.1

* `twitter_bootstrap` - includes `rails_basics`
* `eycloud` - only using `ey_cli` (`engineyard` gem has `net-ssh` conflict with `chef` gem)
* Display scrolls that will be used - explicitly requested (green) and implicitly included (yellow)
* `eycloud` - only unicorn and passenger initially supported
* `eycloud` - don't check for available app name - this should be implemented in ey_cli

### v0.8.2

PUBLIC RELEASE! http://drnicwilliams.com/2012/04/10/instant-new-rails-applications-with-the-app-scrolls/

* `delayed_job` - always get admin dashboard
* `mysql` - always create local databases

### v0.8.3

* `resque` - Use "resque_admin_secret" instead of hardcoded string

### v0.8.4

* `github` - if private, then create private repo [thx @CraigCottingham]
* `thin` - moved to active
* `rails_admin` - new scroll [thx @sferik]
* `twitter_bootstrap` - Added `therubyracer` gem as a dependency [thx @jackdempsey]
* added support for scrolls with dashes in their names [thx @grk]

## v0.7

New name! "App Scrolls"

* `split` - AB testing promoed in RailsCasts
* `spork` - clean running of tests
* `resque` - always includes admin dashboard

Fixed

* `cucumber` - creates databases before running installer

Internal

* Replace ZenTest with Guard
* Add 'rake list:categories' task

### v0.7.1

* Force rails ~> 3.2.2 as a dependency

## v0.6

* `twitter_bootstrap` - automatically includes `simple_form`; includes flash msg
* `github` - asks for a new repo name if cannot create a repository
* `rails_basics` - default flash message
* `jquery` & `prototype` - former is already default in Rails 3.1+ now

New
* `guard` - guard support for all supported scrolls
* `postgresql`
* All untested scrolls moved into scrolls/zzz

## v0.5

* `twitter_bootstrap` - based on public RailsCast
* `eycloud` - now using `ey_cli` to create/boot environments

## v0.4

* SCROLLS ARE IN, "recipes" are out. Wizards use scrolls. Alchemists use recipes.
* Scrolls have no dependencies on `eycloud` or `eycloud_recipes_on_deploy`; these are optional
* `github` - GitHub repository creation
* `resque` + `delayed_job` can install their admin consoles
* `sidekiq` - high performance, low cost alternative to `resque` or `delayed_job`

## v0.3

* Engine Yard support - Resque
* Removed a bunch of recipes that didn't see useful/common

### v0.3.1

* Resque recipe works a treat.

Try this on EY Cloud! `appscrolls new demomysql -r sqlite3 mysql resque rails_basics git`

## v0.2

Merged lots of branches/forks

## v0.2.1

* Cleaned up many recipes
* Added :website attribute to recipes
* Convert all recipes to use supported categories

