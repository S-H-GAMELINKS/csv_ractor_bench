require "sinatra"
require "sinatra/activerecord"
require "rorker"
require "csv"
require "./user.rb"

class CSVRactorBench < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}

  get '/csv' do
    content_type 'text/csv'
    attachment 'test.csv'

    @users = User.all

    csv = CSV.generate do |csv|
      column_names = %w(name address tel)
      csv << column_names
      @users.each do |user|
        column_values = [
          user.name,
          user.address,
          user.tel
        ]
        csv << column_values
      end
    end
    csv
  end

  get '/csv_ractor' do
    content_type 'text/csv'
    attachment 'test.csv'

    task = Ractor.new do
      loop do
        Ractor.yield Ractor.recv
      end
    end

    rorker = Rorker.new(task, worker_count: 1000)

    @users = User.all
    @count = @users.size

    csv = CSV.generate do |csv|
      column_names = %w(name address tel)
      csv << column_names
      @users.each do |user|
        rorker.send [user.name, user.address, user.tel]
      end
      n = 0
      while n < @count
        rorker.run do |worker, result|
          csv << result
        end
        n += 1
      end
    end
    csv
  end
end
