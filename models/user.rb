class User < ActiveRecord::Base
	validates :name, presence: true
	validates :password, presence: true
	validates :email, presence: true, uniqueness: { case_sensitive: true }
end