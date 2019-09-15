class MappedImage < ApplicationRecord
	attachment :image
	belongs_to :user
	has_many :mapped_images_favs

	def mapped_images_fav_by?(user)
		mapped_images_favs.where(user_id: user.id).exists?
	end
end
