require 'sequel'
require 'logger'

DB = Sequel.connect('sqlite://sysinfo.sqlite3', logger: logger || nil)
DB.sql_log_level = :debug

class DataPoint < Sequel::Model
  set_dataset dataset.order(:epoch)
end

class Minute < Sequel::Model
  set_dataset dataset.order(:min)
end
