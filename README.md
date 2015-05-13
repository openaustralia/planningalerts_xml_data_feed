# PlanningAlerts XML Data Feed

Fetches bulk data from the [PlanningAlerts API](https://www.planningalerts.org.au/api/howto) and converts it to XML for use in your legacy systems.

## Usage

* Copy `.env-example` to `.env` and fill in the configuration.
* Install gem dependencies by running `bundle`
* Find a rake task to do your bidding with `bundle exec dotenv rake -T`

## Deployment

This repo is just cloned under `kedumba`'s `deploy` user. There's a cronjob set up to run it each Monday morning at 7AM:

    0 7 * * MON /home/deploy/.rvm/wrappers/ruby-2.0.0-p353/bundle exec dotenv rake transfer_applications[yesterday]
