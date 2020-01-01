class LincolnRiders::ReplyRelationshipsController < ApplicationController

	def new
		@new_post = Post.new
	end

	def create
		post = Post.new(post_params)
		post.user_id = current_user.id
		if post.save
			relation = ReplyRelationship.new(replying_post_id: post.id,replied_post_id: params[:post_id])
			if relation.save
				redirect_to lincoln_riders_post_path(post.id)
				flash[:notice]="[Success] Post was created"
			end
		else
			redirect_to lincoln_riders_user_mypage_path
			flash[:notice]="[Error] Post was not created"
		end
	end

	private
	def post_params
      params.require(:post).permit(:text, :image)
	end

end
