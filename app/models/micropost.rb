class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :context, presence: true, length: {maximum: 100}
  validate :picture_size

  scope :time_line, ->do
    order(:created_at)
  end

  def in_user? user
    self.user_id == user.id
  end

  private

  def picture_size
    errors.add :picture, :greater_than if self.picture.size > 5.megabytes
  end
end
