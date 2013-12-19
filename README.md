#SumTimes

**Commercial Implementation:** https://sumtimes.co

[![Build Status](https://travis-ci.org/Yakrware/sum_times.png)](https://travis-ci.org/Yakrware/sum_times)

##Purpose

SumTimes is an exception-based time tracking and scheduling tool intended for small teams and businesses operating under
flex time schedules. The intent is to build a simple, flexible way to generate timesheets for businesses that don't need
the additional .

##Installation

Sumtimes is a full rails app.

####Requirements:
* RVM
* Ruby 1.9.3 or 2.0.0
* Postgresql (using postgres arrays, making this db dependent)
* Bundler gem

####Installation:

    git clone git://github.com/talho/sum_times.git
    cd sum_times
    bundle install --deployment

Change database.yml to point to your local database and config/unicorn/production.rb to indicate your server preferences then:

    rake db:create db:migrate
    rails c
    Admin.create(email: 'admin_email@example.com', password: 'PasswordExample1')
    exit
    unicorn -c ./config/unicorn/production.rb -E production -D

And now you can log into the site and create normal users.

##Usage

Users create schedules, request leaves, and can view the status of the office. Timesheets are generated as needed for each
pay period. Accruals calculated on the fly.

##Extending

Fork this repository, make changes, submit a pull request.

---

Copyright (c) 2013, Yakrware
All rights reserved.

Licensed under modified BSD to disallow commercial .
