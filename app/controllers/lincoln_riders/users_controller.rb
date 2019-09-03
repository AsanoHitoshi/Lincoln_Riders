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
end
