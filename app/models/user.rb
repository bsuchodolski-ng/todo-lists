class User < ApplicationRecord

  has_secure_password
  has_secure_token :auth_token
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  has_many :to_do_lists #, dependent: :destroy
end
