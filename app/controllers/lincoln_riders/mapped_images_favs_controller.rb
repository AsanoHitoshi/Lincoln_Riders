class LincolnRiders::MappedImagesFavsController < ApplicationController
	before_action :authenticate_user!

	def create
		mapped_images_fav = MappedImagesFav.new(user_id: current_user.id,mapped_image_id: params[:mapped_image_id])
		mapped_images_fav.save
		result = [done: "save",user_id: current_user.id, mapped_image_id: params[:mapped_image_id]]
		render :json => result
	end

	def destroy
		mapped_images_fav = MappedImagesFav.find_by(user_id: current_user.id,mapped_image_id: params[:mapped_image_id])
		mapped_images_fav.destroy
		result = [done: "destroy",user_id: current_user.id, mapped_image_id: params[:mapped_image_id]]
		render :json => result
	end

end
