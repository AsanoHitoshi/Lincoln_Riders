class LincolnRiders::UsersController < ApplicationController
	before_action :authenticate_user!

	PER = 10
	LATEST_PER = 5

	def mypage
		@user = User.find_by(id: current_user.id)
		following_users = @user.following_users

		following_users_id = following_users.pluck(:id)
		shown_user_id = following_users_id.push(@user.id)

		@latest_posts = Post.where(user_id: shown_user_id)
		@latest_posts = @latest_posts.order(id: "DESC").limit(LATEST_PER)

		@latest_mapped_images = MappedImage.where(user_id: shown_user_id)
		@latest_mapped_images = @latest_mapped_images.order(id: "DESC").limit(LATEST_PER)

		@new_post = Post.new
	end

	def mypage_posts
		@user = User.find_by(id: current_user.id)
		following_users = @user.following_users

		following_users_id = following_users.pluck(:id)
		shown_user_id = following_users_id.push(@user.id)

		@posts = Post.where(user_id: shown_user_id)
		@posts = @posts.order(id: "DESC").page(params[:page]).per(PER)

		@new_post = Post.new
	end
	def mypage_mapped_images
		@user = User.find_by(id: current_user.id)
		following_users = @user.following_users

		following_users_id = following_users.pluck(:id)
		shown_user_id = following_users_id.push(@user.id)

		@mapped_images = MappedImage.where(user_id: shown_user_id)
		@mapped_images = @mapped_images.order(id: "DESC").page(params[:page]).per(PER)

		@new_post = Post.new
	end

	def mypage_fav_posts
		@user = User.find_by(id: current_user.id)
		@fav_posts = @user.fav_posts.order(id: "ASC").page(params[:page]).per(PER)
		@new_post = Post.new
	end

	def mypage_fav_mapped_images
		@user = User.find_by(id: current_user.id)
		@fav_mapped_images = @user.fav_mapped_images.order(id: "ASC").page(params[:page]).per(PER)
		@new_post = Post.new
	end

	def show
		@user = User.find_by(id: params[:id])
		@latest_posts = @user.posts.order(id: "DESC").limit(LATEST_PER)
		@latest_mapped_images = @user.mapped_images.order(id: "DESC").limit(LATEST_PER)
		@new_post = Post.new

	end
	def show_posts
		@user = User.find_by(id: params[:id])
		@posts = @user.posts.order(id: "DESC").page(params[:page]).per(PER)
		@new_post = Post.new
	end
	def show_fav_posts
		@user = User.find_by(id: params[:id])
		@posts = @user.fav_posts.order(id: "DESC").page(params[:page]).per(PER)
		@new_post = Post.new
	end
	def show_mapped_images
		@user = User.find_by(id: params[:id])
		@mapped_images = @user.mapped_images.order(id: "DESC").page(params[:page]).per(PER)
		@new_post = Post.new
	end
	def show_fav_mapped_images
		@user = User.find_by(id: params[:id])
		@fav_mapped_images = @user.fav_mapped_images.order(id: "DESC").page(params[:page]).per(PER)
		@new_post = Post.new
	end
	def following_users_index
		@user = User.find_by(id: params[:id])
		@new_post = Post.new
	end

	def followed_users_index
		@user = User.find_by(id: params[:id])
		@new_post = Post.new
	end

	def edit
		@user =User.find_by(id: params[:id])
		if @user.id == current_user.id
		else
			redirect_to lincoln_riders_user_mypage_posts_path
		end
	end
	def update
		user = User.find_by(id: params[:id])
		if user.id == current_user.id
			if user.update(user_params)
				redirect_to lincoln_riders_user_mypage_path
			else
				redirect_to edit_lincoln_riders_user_path(current_user)
			end
		else
			redirect_to edit_lincoln_riders_user_path(current_user)
		end
	end

	def destroy
		@user = User.find_by(id: params[:id])
		if current_user.id == @user.id
			if @user.destroy
				redirect_to lincoln_riders_root_path
				flash[:notice]="[Success] User's info were Deleted"
			else
				redirect_to admins_user_path(@user)
				flash[:notice]="[Error] User's info were not Deleted"
			end
		else
			flash[:notice]="[Error] You are not this User"
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :introduction, :profile_image, :email)
		end
end
