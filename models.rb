class User < ActiveRecord::Base
    validates :first_name, :last_name, :password, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum: 5, max: 8}
    # has_secure_password
end


class Post < ActiveRecord::Base

end
