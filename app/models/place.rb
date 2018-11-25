class Place < ActiveRecord::Base
  validates :name, :street, :city, :state, :category, presence: true
  validates :name, uniqueness: true
  has_many :reviews
end
