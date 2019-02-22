class User < ActiveRecord::Base
  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  has_secure_password
  has_many :reviews
  has_many :places

  def review_alpha_sort
    self.reviews.sort_by { | review | [ review.place.name.downcase, review.title.downcase ] }
  end
end
