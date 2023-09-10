# frozen_string_literal: true

require 'sqlite3'
require 'active_record'
require 'yaml'

db = SQLite3::Database.new('db/development.sqlite3')

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

db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config['development'])

db.close
