require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'
require 'pony'
require 'sinatra/reloader' if development?
# set :port, 3000
configure :development do
  # set :database, {adapter: "postgresql", database: "legends"}
  set :database, {adapter: 'postgresql', database: 'rumblr'}
end
configure :production do
  set :database, {url: ENV['DATABASE_URL']}
end
# set :database, {adapter: "sqlite3", database: "database1.sqlite3"}
enable :sessions
$correctCode = false
puts   @pageTitle2

# def mail_Func(random_Num, emialofuser)
#   Pony.mail({
#     :from => "params[:name]",
#     #  :to => emialofuser,
#     :to => "alshohateeaseel@gmail.com",
#     :subject => "params[:name]" + "has contacted you via the Website",
#     :body => "Your code: #{random_Num}",
#     :via => :smtp,
#     :via_options => {
#       :address              => 'smtp.gmail.com',
#       :port                 => '587',
#       :enable_starttls_auto => true,
#       :user_name            => ENV["MY_EMAIL_USER"],
#       :password             => ENV["MY_EMAIL_PASSWORD"],
#       :authentication       => :plain,
#       :domain               => "localhost.localdomain"
#     }
#     })
#   end
#   # mail_Func(random_Num)

  get '/' do
    if session[:user_id]
      redirect "/profile"
    else
      erb :home
    end
  end
  # ***************************************

  get '/login' do
    @pageTitle="login"
    if session[:user_id]
      redirect "/profile"
    else
      erb :login
    end
  end

  post '/login' do
# puts "dsfgasdfsdfasdfasdf#{user.authenticate(params[:password])}"

    @@email = params[:email]
    user = User.find_by(email: params[:email])
    given_password = params[:password]

    if  !user.nil?
      if user.password == given_password
        session[:user_id] = user.id

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

    @pageTitle = "signup"
    if session[:user_id]
      redirect "/profile"
    else
      erb :signup
    end

  end

  post '/signup' do

    @pageTitle = "signup"
    $user = User.new(params[:user])

    if $user.valid?
      emialofuser = $user.email
      $random_Num = rand.to_s[2..15]
      mail_Func($random_Num, emialofuser)
      redirect '/variationCode'
    else
      flash[:errors] = $user.errors.full_messages
      redirect '/signup'
    end
  end

# ***********variationCode
  get '/variationCode' do
    @pageTitle = "variationCode"
    erb :variationCode
  end

  post '/variationCode' do
    if $random_Num  == params[:code]
      puts "$random_Num  == params[:code]"
       $user.save
       $user = nil
      redirect '/aftersignup'
    else
        puts "$random_Num  =! params[:code]"
      redirect '/signup'
    end
  end
# ************** aftersignup
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
    @post = Post.new(title: params[:title], content: params[:content], user_id: user.first_name)
    puts  "  buytyctyfctrcyc#{@post}"
    @post.update(maker: user.first_name)
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
  get '/updateUserInfo' do
    if session[:user_id] == nil
    redirect "/"
  end
    erb :updateUserInfo
  end

  post '/updateUserInfo' do
    if session[:user_id] == nil
      redirect "/"
    end
    user = User.find_by(id: session[:user_id])
    pp user
    if params[:user][:first_name]!=""
      user.first_name = params[:user][:first_name]
    end
    if params[:user][:last_name] !=""
      user.last_name= params[:user][:last_name]
    end
    if params[:user][:birthday] !=""
      user.birthday= params[:user][:birthday]
    end
    if params[:user][:email] !=""
      user.email= params[:user][:email]
    end
    if params[:user][:password] !=""
      user.password= params[:user][:password]
    end
    user.save
    pp user
    redirect "/profile"

  end
