require "sinatra"
require "sinatra/activerecord"

class CSVRactorBench < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end