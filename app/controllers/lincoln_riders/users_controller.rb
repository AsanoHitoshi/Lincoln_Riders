class LincolnRiders::UsersController < ApplicationController

	def mypage
		if current_user == nil
			redirect_to new_user_session_path
		else
			@user = User.find_by(id:current_user.id)
			@posts = @user.posts
		end
		@new_post = Post.new
	end

	def show
		@user = User.find_by(params[:id])
		@new_post = Post.new
	end

	def following_users_index
		@user = User.find_by(id: params[:id])
	end

	def followed_users_index
		@user = User.find_by(id: params[:id])
	end
end
