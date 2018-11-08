class User < ActiveRecord::Base
  validates :username, presence: true
  validates :email, uniqueness: true
  has_secure_password
  has_many :reviews
end
