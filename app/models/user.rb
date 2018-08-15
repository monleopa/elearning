class User < ApplicationRecord
  before_save {email.downcase!}
  VALID_EMAIL_REGEX = Settings.user_valid.email_syntax
  has_secure_password
  validates :name,  presence: true,
    length: {maximum: Settings.user_valid.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.user_valid.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user_valid.password_length}
  scope :selected, ->{select :id, :name, :email}
  scope :ordered, ->{order name: :asc}
end
