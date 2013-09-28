class User < ActiveRecord::Base
	default_scope -> { order('created_at ASC') }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	
	validates(:name, presence:true, length: { maximum: 100 })
	validates(:email, presence:true, length: { maximum: 200 }, format:{with:VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false })
	validates :password, length: { minimum: 6 }
	
	has_secure_password
	before_create :create_remember_token

	before_save do
		self.email = email.downcase
	end

	def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end	

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end	
end
