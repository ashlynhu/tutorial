class User < ApplicationRecord
	# => before_save - Callback method invoked before instance is saved
	before_save {self.email = email.downcase}	# Set user email to lowercase before save
	# Validate presence of name attribute and that it is appropriate length
	validates(:name, presence: true, length: { maximum: 50})
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false}
    has_secure_password		# method to allow for password functionality
    validates :password, presence: true, length: {minimum: 6}


    # Returns the hash digest of a given string
    def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
    end
end
