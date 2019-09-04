class LincolnRiders::MappedImagesController < ApplicationController

	def index

	end

	def new
		@mapped_image = MappedImage.new
	end

	def create
		mapped_image = MappedImage.new(mapped_image_params)
		mapped_image.user_id = current_user.id
		if mapped_image.save
			redirect_to lincoln_riders_user_mapped_image_path(mapped_image.user_id,mapped_image.id)
		else
			redirect_to new_lincoln_riders_user_mapped_image_path
		end
	end

	def show
		@mapped_image = MappedImage.find_by(params[:id])
		@user = User.find_by(params[:user_id])
	end

	private

		def mapped_image_params
	      params.require(:mapped_image).permit(:user_id,:text, :image, :position_lat, :position_lng,)
		end
end