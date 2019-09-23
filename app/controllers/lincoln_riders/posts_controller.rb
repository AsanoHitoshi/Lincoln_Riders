class LincolnRiders::PostsController < ApplicationController
	before_action :authenticate_user!

PER = 10

	def create
		post = Post.new(post_params)
		post.user_id = current_user.id
		if post.save
			redirect_to lincoln_riders_post_path(post.id)
			flash[:notice]="[Success] Post was created"
		else
			redirect_to new_user_session_path
			flash[:notice]="[Error] Post was not created"
		end
	end
	def index
		@new_post =  Post.new
		@posts = Post.all.order(id: "DESC").page(params[:page]).per(PER)
	end
	def show
		@post = Post.find_by(id: params[:id])
		@user = User.find_by(id: @post.user_id)
		@new_post =  Post.new
	end

	def edit
		@post = Post.find_by(id: params[:id])
		if @post.user_id == current_user.id
			@new_post =  Post.new
		else
			flash[:notice]="[Error] You are not Post's user"
			redirect_to lincoln_riders_post_path(@post.id)
		end
	end

	def update
		post = Post.find_by(id: params[:id])
		if post.user_id == current_user.id
			if post.update(post_params)
				flash[:notice]="[Success] Post was updated"
				redirect_to lincoln_riders_post_path(post)
			else
				flash[:notice]="[Error] Post was not updated"
				redirect_to edit_lincoln_riders_post_path(post)
			end
		else
			flash[:notice]="[Error] You are not Post's user"
			redirect_to lincoln_riders_post_path(@post.id)
		end
	end
	def destroy
		post = Post.find_by(id: params[:id])
		if post.user_id == current_user.id
			if post.destroy
				flash[:notice]="[Success] Post was destroied"
				redirect_to lincoln_riders_user_path(current_user.id)
			else
				flash[:notice]="[Error] Post was not destroied"
				redirect_to lincoln_riders_post_path(@post.id)
			end
		else
			flash[:notice]="[Error] You are not Post's user"
			redirect_to lincoln_riders_post_path(@post.id)
		end
	end

	private
	def post_params
      params.require(:post).permit(:text, :image)
	end
end
