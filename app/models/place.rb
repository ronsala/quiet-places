class Place < ActiveRecord::Base
  validates :name, :street, :city, :state, presence: true
  validates :name, uniqueness: true
  belongs_to :user
  has_many :reviews
end
