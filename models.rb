class User < ActiveRecord::Base
    validates :name, :password, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum: 5, max: 8}
end


class Post < ActiveRecord::Base

end
