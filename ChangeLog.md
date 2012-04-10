# ChangeLog

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

