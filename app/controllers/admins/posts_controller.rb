class Admins::PostsController < ApplicationController
	before_action :authenticate_admin!

	PER =10

	def index
		@posts = Post.all.order(id: "ASC").page(params[:page]).per(PER)
	end

	def show
		@post = Post.find_by(id: params[:id])
	end

	def destroy
		@post = Post.find_by(id: params[:id])
		if @post.destroy
			redirect_to admins_posts_path
		else
			redirect_to admins_post_path(@post)
		end
	end
end
