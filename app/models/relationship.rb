class Relationship < ApplicationRecord
  #lay tat ca object User co id = followed_id trong relationships
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
