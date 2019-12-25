require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'

set :port, 3000
set :database, {adapter: "sqlite3", database: "doggly.sqlite3"}
enable :sessions

get '/' do
    erb :home
end
# ***************************************

get '/login' do
    erb :login
end
post '/login' do
    user = User.find_by(email: params[:email])
    given_password = params[:password]
    if user.password == given_password
        session[:user_id] = user.id
        redirect '/profile'
    else
        flash[:error] = "Correct email but wrong password. did you mean #{user.password}
        \ Only use this password if this is your account"
        redirect '/login'
    end
end



# ***************************************
get '/signup' do
    erb :signup
end

post '/signup' do
    p params
    @user = User.new(params[:user])
    if @user.valid?
        @user.save
        redirect '/profile'
    else
        flash[:errors] = @user.errors.full_messages
        redirect '/signup'
    end
end

get '/profile' do
    erb :profile
end
