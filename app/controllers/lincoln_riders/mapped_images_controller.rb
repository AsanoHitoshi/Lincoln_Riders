class LincolnRiders::MappedImagesController < ApplicationController
	before_action :authenticate_user!

	PER=9

	def index
		@mapped_images = MappedImage.all.order(id: "DESC").page(params[:page]).per(PER)
		@new_post = Post.new
	end

	def search
		@new_post = Post.new
		@mapped_images = []
	end

	def new
		@mapped_image = MappedImage.new
		@new_post = Post.new
	end

	def create
		mapped_image = MappedImage.new(mapped_image_params)
		mapped_image.user_id = current_user.id
		if mapped_image.save
			flash[:notice]="[Success] MappedImage was created"
			redirect_to lincoln_riders_mapped_image_path(mapped_image.id)
		else
			flash[:notice]="[Error] MappedImage was not created"
			redirect_to new_lincoln_riders_mapped_image_path
		end
	end

	def show
		@mapped_image = MappedImage.find_by(id: params[:id])
		@user = User.find_by(id: params[:user_id])
		@new_post = Post.new
	end

	def edit
		@mapped_image = MappedImage.find_by(id: params[:id])
		if @mapped_image.user_id == current_user.id
			@new_post = Post.new
		else
			flash[:notice]="[Error] You are not MappedImage's user"
			redirect_to lincoln_riders_mapped_image_path(@mapped_image.id)
		end
	end

	def update
		mapped_image = MappedImage.find_by(id: params[:id])
		if mapped_image.user_id == current_user.id
			if mapped_image.update(mapped_image_params)
				flash[:notice]="[Success] MappedImage was updated"
				redirect_to lincoln_riders_mapped_image_path(mapped_image.id)
			else
				flash[:notice]="[Error] MappedImage was not updated"
				redirect_to edit_lincoln_riders_mapped_image_path(mapped_image.id)
			end
		else
			flash[:notice]="[Error] You are not MappedImage's user"
			redirect_to edit_lincoln_riders_mapped_image_path(mapped_image.id)
		end
	end

	def destroy
		mapped_image = MappedImage.find_by(id: params[:id])
		if mapped_image.destroy
			redirect_to lincoln_riders_user_mypage_mapped_images_path
		else
			redirect_to new_lincoln_riders_mapped_image_path(mapped_image)
		end
	end


# ajax function
	def get_window_content
		@showing_mapped_image = MappedImage.find_by(id: params[:showing_mapped_image_id])
		@showing_mapped_image.image_id = Refile.attachment_url(@showing_mapped_image, :image)
		render :json => @showing_mapped_image
	end

	def get_near_markers
		all_near_mapped_images = MappedImage.where(position_lat: params[:view_map_range][:sw][:lat].to_f..params[:view_map_range][:ne][:lat].to_f,position_lng: params[:view_map_range][:sw][:lng].to_f..params[:view_map_range][:ne][:lng].to_f)
		fav_rank_mapped_image_ids = MappedImagesFav.where(mapped_image_id: all_near_mapped_images.pluck(:id)).group(:mapped_image_id).order('count(mapped_image_id) desc').limit(5).pluck(:mapped_image_id)
		@near_mapped_images = MappedImage.where(id: fav_rank_mapped_image_ids).order(id: "DESC").page(params[:page]).per(PER)
		content = render_to_string(:partial => 'lincoln_riders/mapped_images/mapped_image_index', locals: {mapped_images: @near_mapped_images} )
		render json: {html: content}, status: :ok
	end

	private

		def mapped_image_params
	      params.require(:mapped_image).permit(:user_id, :text, :image, :position_lat, :position_lng,)
		end
end