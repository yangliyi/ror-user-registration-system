class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :name, :encrypted_password, presence: true
  validates :name, length: { minimum: 5 }, unless: :skip_name_check?
  validates :reset_password_token, uniqueness: true, allow_blank: true

  before_validation :set_default_name, if: :new_record?

  MIN_PASSWORD_LENGTH = 8
  RESET_EXPIRED_HOURS = 6

  def self.min_password_length
    MIN_PASSWORD_LENGTH
  end

  def token_not_expired?
    reset_password_sent_at + RESET_EXPIRED_HOURS.hours > Time.now
  end

  private

  def set_default_name
    self.name = email.split('@')[0]
  end

  def skip_name_check?
    new_record? || !name_changed?
  end
end
