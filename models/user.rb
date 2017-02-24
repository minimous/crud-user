class User < ActiveRecord::Base
	validates :name, presence: true
	validates :password, presence: true
	validates :email, presence: true, uniqueness: { case_sensitive: true }
	has_many :books, dependent: :destroy
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	
	def self.search search_word
		return scoped unless search_word.present?
		where(['name LIKE ?',"%#{search_word}%"])
	end
	
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def self.send_activation_mail(email, token)
		@user = User.find_by email: email
		Pony.mail({
			from: "example@noreply.com",
			to: email,
			via: 'smtp',
			subject: 'Account Activation',
			body: "Hello "+@user.name+", please clicking this link for account activation\n
							http://localhost:4567/activate?token="+token,
			via_options: {
				address: 'smtp.gmail.com',
				port: '587',
				user_name: 'hoai.thai.bks2015',
				password: 'cloneemail',
				authentication: :plain,
				domain: 'localhost:4567'
			}
		})
	end
end