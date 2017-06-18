class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_length}
  validate :picture_size

  mount_uploader :picture, PictureUploader

  scope :feed_by_user,->(user_id){where "user_id = ?", user_id}
  scope :order_date,->{order created_at: :desc}

  private

  def picture_size
    if picture.size > Settings.micropost.picture.max_mb.megabytes
      errors.add :picture, t("micropost.picture_size.error")
    end
  end
end
