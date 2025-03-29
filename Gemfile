source "https://rubygems.org"
ruby "3.3.4"

# Rails Framework
gem "rails", "~> 8.0.1"

# Asset Pipeline for Rails
gem "propshaft"

# Database setup
group :development, :test do
  gem "sqlite3", ">= 2.1"  # SQLite for local development and tests
end

group :production do
  gem "pg", ">= 1.4"  # PostgreSQL for Heroku or production environment
end

# Web server
gem "puma", ">= 5.0"

# Import maps for managing JavaScript dependencies
gem "importmap-rails"

# Hotwire components for interactivity
gem "turbo-rails"      # SPA-like page navigation
gem "stimulus-rails"   # JavaScript framework

# JSON APIs
gem "jbuilder"

# Password hashing
gem "bcrypt", "~> 3.1.7"

# Zone info for time-related functions
gem "tzinfo-data", platforms: %i[windows jruby]

# Bootsnap for faster booting
gem "bootsnap", require: false

# Deployment tools
gem "kamal", require: false  # Docker-based deployment
gem "thruster", require: false  # HTTP asset caching/compression

#selenium driver
gem "selenium-webdriver", "~> 4.0"  # Selenium for browser automation

# Development and Test Group Gems
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "brakeman", require: false  # Security analysis
  gem "rubocop-rails-omakase", require: false  # Style guide
  gem "rack_session_access"
  gem "rack-test"

  # Testing
  gem "rspec-rails"      # RSpec for unit testing
  gem "cucumber-rails", '~> 3.1.1', require: false  # Cucumber for BDD
  gem "database_cleaner-active_record"  # Clean database between tests

  # System tests
  gem "capybara"      # Capybara for feature tests

  gem "dotenv-rails"
end

# Console on error pages in development
group :development do
  gem "web-console"
end

group :test do
  gem "rails-controller-testing"
end

# Benchmarking and interactive Ruby console (included explicitly)
gem "benchmark", "0.4.0"
gem "irb", "1.15.1"
gem "devise"

# QR code generator
gem "rqrcode"

# simple cov
group :test do
  gem "simplecov", require: false
end

gem "image_processing", ">= 1.2"

gem "ruby-vips"

# faker
group :development, :test do
  gem "faker"
end


gem "rubyzip", "~> 2.3"
