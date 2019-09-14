class LincolnRiders::UsersController < ApplicationController

PER = 10

	def mypage_posts
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id:current_user.id)
			@posts = @user.posts.page(params[:page]).per(PER)
		end
		@new_post = Post.new
	end
	def mypage_mapped_images
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id:current_user.id)
			@mapped_images = @user.mapped_images.page(params[:page]).per(PER)
		end
		@new_post = Post.new
	end

	def show_posts
		@user = User.find_by(params[:id])
		@posts = @user.posts.page(params[:page]).per(PER)
		@new_post = Post.new
	end
	def show_mapped_images
		@user = User.find_by(params[:id])
		@mapped_images = @user.mapped_images.page(params[:page]).per(PER)
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

end
