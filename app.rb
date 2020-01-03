
require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require 'pony'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'mini_magick'
require 'sinatra/reloader' if development?
require './models'
require 'fog-aws'
set :port, 3000
set :database, {adapter: "sqlite3", database: "database1.sqlite3"}
enable :sessions

  s3 = Fog::Storage.new(provider: 'AWS', region: 'eu-central-1')
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['SECRET_ACCESS_KEY'],
  }
  config.fog_directory  = 'rumblrblog'
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end

class Uploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog
  def store_dir
    'images'
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  version :thumb do
    process :resize_to_fill => [200, 200]
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

class Image < ActiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :file, Uploader
end


  get "/" do
    @images = Image.all
    erb :index
  end

  get "/upload" do
    erb :upload
  end

  post "/upload" do
    puts "asdfasdfasfas#{params[:image]}"
    image = Image.create(post_id:"1")
    redirect '/'

  end
