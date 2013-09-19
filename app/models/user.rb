class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates(:name, presence:true, length: { maximum: 100 })
	validates(:email, presence:true, length: { maximum: 200 }, format:{with:VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false })
	validates :password, length: { minimum: 6 }
	
	has_secure_password

	before_save do
		self.email = email.downcase
	end
end
