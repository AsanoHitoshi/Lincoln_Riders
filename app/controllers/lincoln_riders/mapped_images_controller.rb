class LincolnRiders::MappedImagesController < ApplicationController

PER=10

	def index
		@mapped_images = MappedImage.all.page(params[:page]).per(PER)
		@new_post = Post.new
	end

	def new
		@mapped_image = MappedImage.new
		@new_post = Post.new
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
		@mapped_image = MappedImage.find_by(id: params[:id])
		@user = User.find_by(id: params[:user_id])
		@new_post = Post.new
	end

	def edit
		@mapped_image = MappedImage.find_by(id: params[:id])
	end

	def destroy
		mapped_image = MappedImage.find_by(id: params[:id])
		if mapped_image.destroy
			redirect_to lincoln_riders_user_mypage_mapped_images_path
		else
			redirect_to new_lincoln_riders_user_mapped_image_path(mapped_image)
		end
	end

	def get_window_content
		@showing_mapped_image = MappedImage.find_by(id: params[:showing_mapped_image_id])
		@showing_mapped_image.image_id = Refile.attachment_url(@showing_mapped_image, :image)
		render :json => @showing_mapped_image
		# render "get_window_content.js.erb"
	end

	# def reload_map_pin
	# 	x = 1
	# 	radius = params[:zoom] * params[:height] * x
	# 	min_lat = params[:cnter_position_lat]-radius
	# 	max_lat = params[:cnter_position_lat]+radius
	# 	min_lng = params[:cnter_position_lng]-radius
	# 	max_lng = params[:cnter_position_lng]+radius
	# 	@mapped_images = MappedImage.where(position_lat: min_lat..max_lat, position_lng: min_lng..max_lng)
	# end

	private

		def mapped_image_params
	      params.require(:mapped_image).permit(:user_id, :text, :image, :position_lat, :position_lng,)
		end
end