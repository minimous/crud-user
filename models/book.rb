class Book < ActiveRecord::Base
	has_many :bookreviews, dependent: :destroy

	def self.book_from_user user_id
		return scoped unless user_id.present?
		where(['user_id = ?',"#{user_id}"])
	end

	def author
		@user = User.find_by id: self.user_id
		return @user.name
	end
end