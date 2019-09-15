class MappedImagesFav < ApplicationRecord
	belongs_to :user
	belongs_to :mapped_image

end
