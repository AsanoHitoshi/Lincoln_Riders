class LincolnRiders::UsersController < ApplicationController
	before_action :authenticate_user!
PER = 10
LATEST_PER = 5
	def mypage
		@user = User.find_by(id: current_user.id)
		@latest_posts = @user.posts.order(id: "ASC").limit(LATEST_PER)
		@latest_posts = @latest_posts.page(params[:page]).per(LATEST_PER)
		@latest_mapped_images = @user.mapped_images.order(id: "ASC").limit(LATEST_PER).page(params[:page]).per(LATEST_PER)
		@new_post = Post.new
	end

	def mypage_posts
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id: current_user.id)
			@posts = @user.posts.order(id: "ASC").page(params[:page]).per(PER)
		end
		@new_post = Post.new
	end
	def mypage_mapped_images
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id: current_user.id)
			@mapped_images = @user.mapped_images.order(id: "ASC").page(params[:page]).per(PER)
		end
		@new_post = Post.new
	end

	def mypage_fav_posts
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id: current_user.id)
			@fav_posts = @user.fav_posts.order(id: "ASC").page(params[:page]).per(PER)
		end
		@new_post = Post.new
	end

	def mypage_fav_mapped_images
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id: current_user.id)
			@fav_mapped_images = @user.fav_mapped_images.order(id: "ASC").page(params[:page]).per(PER)
		end
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
	end
	def update
		@user = User.find_by(id: params[:id])
		if @user.update(user_params)
			redirect_to lincoln_riders_user_mypage_posts_path
		else
		end

	end

	private
		def user_params
			params.require(:user).permit(:name, :introduction, :profile_image, :email)
		end
end
