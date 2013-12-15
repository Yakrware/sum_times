#ruby=2.0.0-p353@sumtimes

source 'https://rubygems.org'

gem 'rails'
gem 'jbuilder'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'devise'

gem 'week_of_month'
gem 'dynamic_form'
gem "actionmailer-with-request", "~> 0.4.0"
gem 'whenever', :require => false, :git => 'https://github.com/javan/whenever.git'

gem 'underscore-rails'

gem 'figaro'
gem 'cancan'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap-sass', :git => 'https://github.com/thomas-mcdonald/bootstrap-sass.git'
gem 'parallel588-bootstrap-timepicker-rails', :require => 'bootstrap-timepicker-rails'
gem 'bootstrap-datepicker-rails'
gem 'momentjs-rails'

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'turbolinks'

# Use unicorn as the app server
group :production do
  gem 'unicorn'
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano', :require => false
  gem 'capistrano-rails', :require => false
  gem 'rvm1-capistrano3', :require => false
  gem 'capistrano3-unicorn', :require => false
  gem "byebug"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'rspec-given'
  gem 'shoulda'
end
