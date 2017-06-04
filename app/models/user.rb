class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :remember_token, :activation_token, :reset_token

  enum role: {admin: 1, user: 0}

  has_many :microposts
  has_many :followed_relationships,
           foreign_key: :follower_id,
           dependent: :destroy,
           class_name: "Relationship"
  has_many :follower_relationships,
           foreign_key: :followed_id,
           dependent: :destroy,
           class_name: "Relationship"
  # user co nhieu active_relationship thuoc class relationship
  # khoa ngoai la follower_id
  has_many :followings, through: :followed_relationships, source: :followed
  has_many :followers, through: :follower_relationships
  # user co nhieu followings thong qua active_relationships
  # doi hoi trong active_ralationship phai co thuoc tinh following_id
  # tuy nhien ko co. source thay alias thanh followed_id
  # join va select * tat ca "User" class duoc dinh nghia
  # tai belongs_to (relationship.rb)
  # voi active_relationships sao cho followed_id o relationship = User.id
  # where @user.foreign_key (follower_id) = params cho truoc

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  before_save :email_downcase
  before_create :create_activation_digest

  class << self
    def digest string
      if cost = ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def send_account_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def follow user
    followings << user
  end

  def unfollow user
    followings.delete user
  end

  def is_following? user
    followings.include? user
  end

  private

  def email_downcase
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
