class Place < ActiveRecord::Base
  validates :name, :street, :city, presence: true
  validates :name, uniqueness: true
  belongs_to :user
  has_many :reviews
end
