#SumTimes

**Commercial Implementation:** https://sumtimes.co

[![Build Status](https://travis-ci.org/Yakrware/sum_times.png)](https://travis-ci.org/Yakrware/sum_times)

##Purpose

SumTimes is an exception-based time tracking and scheduling tool intended for small teams and businesses operating under
flex time schedules. The intent is to build a simple, flexible way to generate timesheets for businesses that don't need
a monolithic tracking implementation.

##Installation

Sumtimes is a full rails app.

####Requirements:
* Ruby > 1.9.3
* Postgresql (using postgres arrays, making this db dependent)

####Installation:

    git clone git://github.com/talho/sum_times.git
    cd sum_times
    bundle install --deployment

Create application.yml with keys for 'RAILS_SECRET_TOKEN', 'RAILS_SECRET_KEY_BASE', 'DEVISE_SECRET_TOKEN', and 'DATABASE_NAME'
and config/unicorn/production.rb to indicate your server preferences. Then:

    rake db:create db:migrate
    unicorn -c ./config/unicorn/production.rb -E production -D

Register as a new company and use the site as normal.

##Usage

Users create schedules, request leaves, and can view the status of the office. Timesheets are generated as needed for each
pay period. Accruals calculated on the fly.

##Extending

Fork this repository, make changes, submit a pull request.

---

Copyright (c) 2013, Yakrware
All rights reserved.

Licensed under modified BSD to disallow commercial .
