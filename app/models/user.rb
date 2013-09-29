class User < ActiveRecord::Base
	default_scope -> { order('users.created_at ASC') }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_many :microposts, dependent: :destroy
	
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	
	has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

	validates(:name, presence:true, length: { maximum: 100 })
	validates(:email, presence:true, length: { maximum: 200 }, format:{with:VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false })
	validates :password, length: { minimum: 6 }
	validates :timezone, presence: true
	
	has_secure_password
	after_initialize :init
	before_create :create_remember_token
	
	def init
		self.timezone ||= User.user_default_timezone
	end

	before_save do
		self.email = email.downcase
		self.timezone ||= User.user_default_timezone
	end

	def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

	def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end  

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

  def User.user_default_timezone
    "UTC"
  end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end	
end
