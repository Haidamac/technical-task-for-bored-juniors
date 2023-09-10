# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Use SQLite as the database for Active Record
gem 'sqlite3', '~> 1.6', '>= 1.6.4'

# HTTP and REST client for Ruby
gem 'rest-client', '~> 2.1'

# JSON implementation for Ruby
gem 'json', '~> 2.6', '>= 2.6.3'

# Build a persistent domain model by mapping database tables to Ruby classes
gem 'activerecord', '~> 7.0', '>= 7.0.7.2'

# Building powerful command-line interfaces
gem 'thor', '~> 1.2', '>= 1.2.2'

group :development do
  # Ruby code style checking
  gem 'rubocop', '~> 1.56', '>= 1.56.2'

  # code style checking for RSpec files
  gem 'rubocop-rspec', '~> 2.24'
end

group :test do
  # Rspec testing tool
  gem 'rspec', '~> 3.12'

  # stubbing HTTP requests and setting expectations on HTTP requests
  gem 'webmock', '~> 3.19', '>= 3.19.1'

  # used to ensure a clean slate for testing
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
end
