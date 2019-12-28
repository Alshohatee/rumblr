require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'
require 'pony'
require 'sinatra/reloader' if development?
set :port, 3000
set :database, {adapter: "sqlite3", database: "database1.sqlite3"}
enable :sessions

puts   @pageTitle2
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
  # mail_Func()

  get '/' do
    if session[:user_id]
      redirect "/profile"
    else
      erb :home
    end
  end
  # ***************************************

  get '/login' do
    @pageTitle = "signup"
    if session[:user_id]
      redirect "/profile"
    else
      erb :login
    end
  end

  post '/login' do
    @aseel = "yes"
    @@email = params[:email]
    user = User.find_by(email: params[:email])
    given_password = params[:password]
    if given_password != ""
      if user.password == given_password
        session[:user_id] = user.id
        puts "asdfasdf #{session[:user_id]}"
        @pageTitle2 = "yes"
        redirect '/profile'
      else
        flash[:error] = "Correct email but wrong password."
        redirect '/login'
      end
    else
      @mes = "worng info find"
      erb:login
    end
  end



  # ***************************************
  get '/signup' do
    @aseel = "yes"
    @pageTitle = "signup"
    if session[:user_id]
      redirect "/profile"
    else
      erb :signup
    end
  end

  post '/signup' do
    @aseel = "yes"
    @pageTitle = "signup"
    p params
    user = User.new(params[:user])
    @name = user.name
    puts "name #{user.name}"
    p !user.valid?
    if user.valid?
      user.save
      redirect '/aftersignup'
    else
      flash[:errors] = user.errors.full_messages
      redirect '/signup'
    end
  end

  get '/aftersignup' do
    @aseel = "yes"
    @pageTitle = "aftersignup"
    erb :aftersignup
  end

  get '/profile' do
    @user = User.find_by(id: session[:user_id])

    @posts = Post.all
    erb :profile
  end

  #************************************
  get "/logout" do
    @aseel = "yes"

    session.clear
    redirect "/"
  end

  post "/logout" do
    @aseel = "yes"
    pp session.methods
    session.clear
    redirect "/"
  end

  #************************************
  get "/dashboard" do
    @pageTitle = "dashboard"
    @posts = Post.all
    if session[:user_id]
      erb :dashboard
    else
      redirect "/"
    end
  end

  post "/dashboard" do
    user = User.find_by(id: session[:user_id])
    puts "sdfasdgagdasdfasdfa#{user.name}"
    @post = Post.new(title: params[:title], content: params[:content], user_id: user.name)
    puts  "  buytyctyfctrcyc#{@post}"
    @post.update(maker: user.name)
    @post.save
    redirect "/dashboard"
  end
  post "/delete" do
    user = User.find_by(id: session[:user])
    user.destroy
    session.clear
    redirect "/terminated"
  end
  # delete a post
  post "/profile/:title" do
    s = params['title'].to_s
    s.slice! ":"
    post = Post.find_by(id: s.to_i)
    post.destroy

    redirect "/profile"
  end

  post "/delete-user" do
    user = User.find_by(id: session[:user_id])
    user.destroy
    session.clear
    redirect "/"
  end
