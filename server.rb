require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'

set :port, 3000
set :database, {adapter: "sqlite3", database: "doggly.sqlite3"}


get '/' do
    erb :home
end
get '/' do
    erb :layout
end
