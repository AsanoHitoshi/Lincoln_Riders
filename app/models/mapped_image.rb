class MappedImage < ApplicationRecord
	attachment :image
	belongs_to :user
	has_many :mapped_images_favs

	validates :text, length: {maximum:20}, presence: true
	validates :image, presence: true
	validates :position_lat, presence: true , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
	validates :position_lng, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

	def mapped_images_fav_by?(user)
		mapped_images_favs.where(user_id: user.id).exists?
	end
end
