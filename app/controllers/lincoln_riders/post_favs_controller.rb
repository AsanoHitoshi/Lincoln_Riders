class LincolnRiders::PostFavsController < ApplicationController

	def create
		@post_fav = PostFav.new(user_id: current_user.id,post_id: params[:post_id])
		@post_fav.save
		result = [done: "save",user_id: current_user.id, post_id: params[:post_id]]
		render :json => result
	end

	def destroy
		@post_fav = PostFav.find_by(user_id: current_user.id, post_id: params[:post_id])
		@post_fav.destroy
		result = [done: "destroy",user_id: current_user.id, post_id:params[:post_id]]
		render :json => result
	end

end
