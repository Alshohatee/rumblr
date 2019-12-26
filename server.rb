require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'
require 'pony'
set :port, 3000
set :database, {adapter: "sqlite3", database: "database1.sqlite3"}
enable :sessions

def mail_Func
Pony.mail({
:from => "params[:name]",
   :to => ENV["TO_EMAIL"],
   :subject => "params[:name]" + "has contacted you via the Website",
   :body => "params[:comment]",
   :via => :smtp,
   :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => ENV["MY_EMAIL_USER"],
    :password             => ENV["MY_EMAIL_PASSWORD"],
    :authentication       => :plain,
    :domain               => "localhost.localdomain"
    }
   })
end
mail_Func()


get '/' do
  if session[:user_id]
    redirect "/profile"
  else
    erb :home
  end
end
# ***************************************

get '/login' do
  if session[:user_id]
    redirect "/profile"
  else
    erb :login
  end
end
post '/login' do
  user = User.find_by(email: params[:email])
  given_password = params[:password]
  if user.password == given_password
    session[:user_id] = user.id
    $loged = true
    redirect '/profile'
  else
    flash[:error] = "Correct email but wrong password. did you mean #{user.password}
    \ Only use this password if this is your account"
    redirect '/login'
  end
end



# ***************************************
get '/signup' do
  if session[:user_id]
    redirect "/profile"
  else
    erb :signup
  end
end

post '/signup' do
  p params
  @user = User.new(params[:user])
  p @user.valid?
  if @user.valid?
    $loged = true
    @user.save
    redirect '/aftersignup'
  else
    flash[:errors] = @user.errors.full_messages
    redirect '/signup'
  end
end

get '/aftersignup' do
  erb :aftersignup
end

get '/profile' do
  erb :profile
end
#************************************
get "/logout" do
    session.clear
  redirect "/"
end

post "/logout" do
  pp session.methods
  session.clear
  redirect "/"
end
