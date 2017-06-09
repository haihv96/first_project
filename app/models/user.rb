class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token, :current_password

  enum role: {admin: 1, basic: 0}
  enum gender: {female: 0, male: 1, other: 2}

  validates :name, presence: true,
    length: {maximum: Settings.user.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.user.max_length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, allow_nil: true,
    length: {maximum: Settings.user.max_length_name}

  validates :current_password, presence: true, allow_nil: true

  before_save :downcase_email

  scope :order_id, -> {order id: :ASC}

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? remember_token
    digest = self.send "remember_digest"
    return false unless digest.present?
    BCrypt::Password.new(digest).is_password? remember_token
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  def send_change_password_mail
    UserMailer.change_password(self).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def is_update_password?
    return false
  end

  def is_not_update_password?
    return true unless is_update_password?
  end
end
