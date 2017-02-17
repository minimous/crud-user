class User < ActiveRecord::Base
	validates :name, presence: true
	validates :password, presence: true
	validates :email, presence: true, uniqueness: { case_sensitive: true }

	def self.search search_word
		return scoped unless search_word.present?
		where(['name LIKE ?',"%#{search_word}%"])
	end
end