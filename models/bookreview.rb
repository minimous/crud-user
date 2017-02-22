class BookReview < ActiveRecord::Base

	def self.find_all_reviews book_id
		reviews = Array.new
		all_reviews = BookReview.all.each do |i|
			if i.book_id == book_id
				reviews << i
			end
		end
		reviews
	end

end