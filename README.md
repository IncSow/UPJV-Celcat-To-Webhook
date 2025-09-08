# About this project


## Requirements : 
Ruby installed ( coded in ruby 3.2.2, untested everywhere else )
The gems  installed localy
Chrome or chromium to run ferrum (the headless browser used to crawl the pages)
A .env file containing these informations : 
- WEBHOOK
- USERNAME
- PASSWORD

## How to run : 

Install the gems using `bundle install` then simply run the schedule_notifier.rb.
You'll need to setup a webhook url in discord for it to properly send you messages.

Ideally, this would run as a cronjob, everyday (except saturday.)
