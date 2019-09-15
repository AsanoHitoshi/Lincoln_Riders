class Post < ApplicationRecord
	attachment :image
	belongs_to :user
	has_many :post_favs


	def post_fav_by?(user)
		post_favs.where(user_id: user.id).exists?
	end
end
