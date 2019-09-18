class LincolnRiders::PostsController < ApplicationController

PER = 10

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to lincoln_riders_post_path(@post.id)
		else
			redirect_to new_user_session_path
		end
	end
	def index
		@new_post =  Post.new
		@posts = Post.all.order(id: "ASC").page(params[:page]).per(PER)
	end
	def show
		@post = Post.find_by(id: params[:id])
		@user = User.find_by(id: @post.user_id)
		@new_post =  Post.new
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
