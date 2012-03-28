# ChangeLog

* `twitter_bootstrap` - based on latest RailsCast

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

Try this on EY Cloud! `ey_rails_wizard new demomysql -r sqlite3 mysql resque rails_basics git`

## v0.2

Merged lots of branches/forks

## v0.2.1

* Cleaned up many recipes
* Added :website attribute to recipes
* Convert all recipes to use supported categories

