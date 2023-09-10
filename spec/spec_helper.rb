# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'sqlite3'
require 'database_cleaner'
require_relative '../lib/wrapper'

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  db = SQLite3::Database.new('db/test.sqlite3')

  db.execute(<<-SQL)
    CREATE TABLE IF NOT EXISTS activities (
      id INTEGER PRIMARY KEY,
      activity TEXT,
      type TEXT,
      participants INTEGER,
      price REAL,
      link TEXT,
      key TEXT,
      accessibility REAL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL

  ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
  ActiveRecord::Base.establish_connection(:test)

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  def capture_output
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
