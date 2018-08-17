class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase!}
  VALID_EMAIL_REGEX = Settings.user_valid.email_syntax
  has_secure_password
  validates :name,  presence: true,
    length: {maximum: Settings.user_valid.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.user_valid.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_valid.password_length}, allow_nil: true
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

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
