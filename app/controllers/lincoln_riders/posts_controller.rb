class LincolnRiders::PostsController < ApplicationController

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to new_user_session_path
		else
			redirect_to new_user_session_path
		end
	end

	def show
		@user = User.find_by(params[:user_id])
		@post = Post.find_by(params[:id])
	end

	private
	def post_params
      params.require(:post).permit(:text, :image)
	end
end
