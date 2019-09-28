class Post < ApplicationRecord
	attachment :image
	belongs_to :user
	has_many :post_favs, dependent: :destroy

	validates :text, length: {maximum:819}
	validates :text, presence: true

	def post_fav_by?(user)
		post_favs.where(user_id: user.id).exists?
	end
end
