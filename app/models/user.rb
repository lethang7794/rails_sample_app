class User < ApplicationRecord
	has_many :microposts, dependent: :destroy

	attr_accessor :remember_token, :activation_token, :reset_token
	before_create :create_activation_digest
	before_save 	:downcase_email

  validates :name,  presence: true,
  									length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+-\.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
  									length: { maximum: 255 },
  									format: { with: VALID_EMAIL_REGEX},
  									uniqueness: true

	has_secure_password
	validates :password, presence: true,
												length: { minimum: 6 }, allow_nil: true

	# Returns random token used for remember me, account activation, password reset.
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# Return the hash digest for the given string
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Remember the user in the dababase for use in persisten sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Return true if remember token match the remember digest in the database
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forgets a user
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Activates a user.
	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
	end

	# Sends activation email to a user.
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# Sets password resets attribute
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(
			reset_digest: User.digest(reset_token),
			reset_sent_at: Time.zone.now
		)
	end

	# Sends password reset email to a user
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if a passwrd reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	private
		# Converts email to all in lower case
		def downcase_email
			email.downcase!
		end

		# Creates and assigns activation token and digest
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
