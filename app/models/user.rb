class User < ApplicationRecord
  belongs_to :contract

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  before_create :generate_authentication_token

  def generate_authentication_token
    self.authentication_token = SecureRandom.urlsafe_base64(32)
  end
end
