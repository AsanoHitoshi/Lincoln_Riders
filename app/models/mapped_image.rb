class MappedImage < ApplicationRecord
	attachment :image
	belongs_to :user
end
