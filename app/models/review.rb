class Review < ActiveRecord::Base
  validates :title, :body, presence: true
  belongs_to :user
  belongs_to :place
end
