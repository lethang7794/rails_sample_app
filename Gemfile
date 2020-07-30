source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0', '>= 6.0.3.2'

# Use Puma as the app server
gem 'puma', '~> 4.3'

# Use SCSS for stylesheets
gem 'sassc-rails', '>= 2.1.0'

# Use Bootstrap 3
gem 'bootstrap-sass', '~> 3.4.1'

# Used to easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '~> 2.11'

# Paginates index pages
gem 'will_paginate', '~> 3.3'
gem 'bootstrap-will_paginate', '~> 1.0'

# Figure the active in navbar
gem 'active_link_to', '~> 1.0', '>= 1.0.5'

# Use Commontator for comments feature
gem 'commontator'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Add validation to Active Storage
gem 'active_storage_validations', '~> 0.1'

# Use Active Storage variant
gem 'image_processing', '~> 1.11'
# Use ImageMagick to change image size, user
gem 'mini_magick', '~> 4.10', '>= 4.10.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.4'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Add multi-platform favicon.
  gem 'rails_real_favicon'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'minitest-reporters', '~> 1.1', '>= 1.1.11'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'

  # Use Guard to handle events on file system modifications
  gem 'guard', '~> 2.16', '>= 2.16.2'
  # Run your tests with Minitest framework with Guard
  gem 'guard-minitest', '~> 2.4', '>= 2.4.6'
end

group :production do
  # Use Postgres for Heroku deployment
  gem 'pg', '~> 0.18.4'

  # Use AWS S3 to store images
  gem 'aws-sdk-s3', '~> 1.67', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
