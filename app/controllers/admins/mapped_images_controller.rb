class Admins::MappedImagesController < ApplicationController
	before_action :authenticate_admin!

PER=10

	def index
		@mapped_images = MappedImage.all.order(id: "ASC").page(params[:page]).per(PER)
	end

	def show
		@mapped_image = MappedImage.find_by(id: params[:id])
	end

	def destroy
		@mapped_image = MappedImage.find_by(id: params[:id])
		if @mapped_image.destroy
			redirect_to admins_mapped_images_path
		else
			redirect_to admins_mapped_image_path(@mapped_image)
		end
	end
end
