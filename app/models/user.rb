class User < ApplicationRecord
	has_many :microposts, dependent: :destroy

	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed

	has_many :passive_relationships, class_name: "Relationship",
																	foreign_key: "followed_id",
																	dependent: :destroy
	has_many :followers, through: :passive_relationships, source: :follower

	attr_accessor :remember_token, :activation_token, :reset_token
	before_create :create_activation_digest
	before_save 	:downcase_email
	before_validation   :generate_username

  validates :name,  presence: true,
  									length: { maximum: 50 }

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\Z/
	validates :username, 	uniqueness: true,
												length: { maximum: 20 },
												format: { with: VALID_USERNAME_REGEX, massage: "may only contain alphanumeric characters."}

	VALID_EMAIL_REGEX = /\A[\w+-\.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
  									length: { maximum: 255 },
  									format: { with: VALID_EMAIL_REGEX},
  									uniqueness: true

	has_secure_password
	validates :password, presence: true,
												length: { minimum: 6 }, allow_nil: true

	validates :bio,       length: { maximum: 200 }
	validates :location,  length: { maximum: 30 }

	# Returns random token used for remember me, account activation, password reset.
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# Return the hash digest for the given string.
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Remember the user in the dababase for use in persisten sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Return true if remember token match the remember digest in the database.
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

	# Sets password resets attribute.
	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(
			reset_digest: User.digest(reset_token),
			reset_sent_at: Time.zone.now
		)
	end

	# Sends password reset email to a user.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if a passwrd reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	# Defines a proto-feed.
	def feed
		followed_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		Micropost.where("user_id = :user_id OR user_id IN (#{followed_ids})", user_id: id)
	end

	# Returns microposts with media.
	def media
		Micropost.joins(:image_attachment).where(user_id: id)
	end

	# Follows another user.
	def follow(an_other_user)
		following << an_other_user
	end

	# Unfollows another user.
	def unfollow(an_other_user)
		following.delete(an_other_user)
	end

	# Return true if the current user is following an other user.
	def following?(an_other_user)
		following.include?(an_other_user)
	end

	# Replace words in bio begin with @, # with hyperlink.
	def bio_display
		self.bio.gsub(/(?<hash>#\S+)/, '<a href="#">\k<hash></a>').gsub(/(?<at>@\S+)/, '<a href="#">\k<at></a>')
	end

	private
		# Converts email to all in lower case
		def downcase_email
			email.downcase!
		end

		# Generates a random username for user
		def generate_username
			if self.username.blank?
				num = rand 0..999999
				firstname = self.name.split.first
				self.username = firstname[0..13] + "#{num}"
			end
		end

		# Creates and assigns activation token and digest
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
