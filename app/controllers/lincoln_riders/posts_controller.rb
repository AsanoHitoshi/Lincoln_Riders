class LincolnRiders::PostsController < ApplicationController

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to lincoln_riders_user_post_path(@post.user_id,@post.id)
		else
			redirect_to new_user_session_path
		end
	end

	def show
		@user = User.find_by(params[:user_id])
		@post = Post.find_by(params[:id])
	end

	def edit
		@post = Post.find_by(params[:id])
	end

	def update
		post = Post.find_by(params[:id])
		if post.update(post_params)
			redirect_to lincoln_riders_user_post_path(post.user_id,post.id)
		else
			redirect_to edit_lincoln_riders_user_post_path(post.user_id,post.id)
		end
	end
	def destroy
		post = Post.find_by(params[:id])
		if post.destroy
			redirect_to lincoln_riders_user_path(current_user.id)
		else
		end
	end

	private
	def post_params
      params.require(:post).permit(:text, :image)
	end
end
