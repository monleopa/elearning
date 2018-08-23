class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  VALID_EMAIL_REGEX = Settings.user_valid.email_syntax
  mount_uploader :avatar, AvatarUploader

  has_secure_password
  validates :name,  presence: true,
    length: {maximum: Settings.user_valid.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.user_valid.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_valid.password_length}, allow_nil: true
  validate :avatar_size

  scope :selected, ->{select :id, :name, :email}
  scope :ordered, ->{order name: :asc}

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_available?
    reset_sent_at > Settings.alive_time.reset_password.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def avatar_size
    if avatar.size > Settings.user_valid.avatar_size.megabytes
      errors.add :avatar, t(".image_alert")
    end
  end
end
