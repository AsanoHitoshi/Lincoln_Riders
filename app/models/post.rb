class Post < ApplicationRecord

	attachment :image

	belongs_to :user
	has_many :post_favs, dependent: :destroy

	has_many :active_post_relationships, 	class_name: "ReplyRelationship", foreign_key: :replying_post_id
	has_many :replying_posts, through: :active_post_relationships, source: :replied_post

	has_many :passive_post_relationships, class_name: "ReplyRelationship", foreign_key: :replied_post_id
	has_many :replied_posts, through: :passive_post_relationships, source: :replying_post


	validates :text, length: {maximum:819}
	validates :text, presence: true


	def post_fav_by?(user)
		post_favs.where(user_id: user.id).exists?
	end
end
