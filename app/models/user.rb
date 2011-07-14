class User < ActiveRecord::Base
  has_many :replies 
  has_many :topics
  validates :username, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validates :email, :location, :presence => true
  class << self
    def authenticate(username, password)
      if user = find_by_username(username)
        if user.password == password
          user
        end
      end
    end
  end
end
