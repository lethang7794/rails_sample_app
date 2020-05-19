class User < ApplicationRecord
	attr_accessor :remember_token

	before_save { email.downcase! }

  validates :name,  presence: true,
  									length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+-\.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
  									length: { maximum: 255 },
  									format: { with: VALID_EMAIL_REGEX},
  									uniqueness: true

	has_secure_password
	validates :password, presence: true,
												length: { minimum: 6 }

	# Return the hash digest for the given string
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Return random token used for remember me
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# Remember the user in the dababase for use in persisten sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Return true if remember token match the remember digest in the database
	def authenticated?(remember_token)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
end
