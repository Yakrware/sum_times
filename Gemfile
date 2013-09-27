#ruby=2.0.0@sumtimes

source 'https://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'devise'

gem 'bootstrap-sass', :git => 'https://github.com/thomas-mcdonald/bootstrap-sass.git'
gem 'parallel588-bootstrap-timepicker-rails', :require => 'bootstrap-timepicker-rails'
gem 'bootstrap-datepicker-rails'
gem 'week_of_month'
gem 'dynamic_form'
gem "actionmailer-with-request", "~> 0.4.0"
gem 'whenever'

gem 'figaro'
gem 'cancan'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

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
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano-unicorn'
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
