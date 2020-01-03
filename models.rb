
class User < ActiveRecord::Base
    validates :first_name, :last_name, :password, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum: 5, max: 8}
    # has_secure_password
end


class Post < ActiveRecord::Base

end
#
# CarrierWave.configure do |config|
#   config.fog_credentials = {
#     :provider               => 'AWS',
#     :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
#     :aws_secret_access_key  => ENV['SECRET_ACCESS_KEY'],
#   }
#   config.fog_directory  = 'rumblrblog'
#   config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
# end
#
# class Image < ActiveRecord::Base
#   extend CarrierWave::Mount
#   mount_uploader :file, PictureUploader
# end

# class PictureUploader < CarrierWave::Uploader::Base
#   include CarrierWave::MiniMagick
#
#   storage :fog
#   def store_dir
#     'images'
#   end
#
#   def filename
#     "#{secure_token}.#{file.extension}" if original_filename.present?
#   end
#
#   version :thumb do
#     process :resize_to_fill => [200, 200]
#   end
#
#   protected
#   def secure_token
#     var = :"@#{mounted_as}_secure_token"
#     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
#   end
# end
# #
# # class App < Sinatra::Base
# #   get "/" do
# #     @images = Image.all
# #     erb :index
# #   end
# #
# #   get "/upload" do
# #     erb :upload
# #   end
# #
# #   post "/upload" do
# #     Image.create(params[:image])
# #     redirect '/'
# #   end
# # end
