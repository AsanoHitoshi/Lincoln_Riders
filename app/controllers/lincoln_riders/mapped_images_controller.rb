class LincolnRiders::MappedImagesController < ApplicationController

PER=10

	def index
		@mapped_images = MappedImage.all.order(id: "ASC").page(params[:page]).per(PER)
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
			redirect_to lincoln_riders_mapped_image_path(mapped_image.id)
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

	private

		def mapped_image_params
	      params.require(:mapped_image).permit(:user_id, :text, :image, :position_lat, :position_lng,)
		end
end