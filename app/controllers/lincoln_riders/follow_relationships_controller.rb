class LincolnRiders::FollowRelationshipsController < ApplicationController
	before_action :authenticate_user!
  def create
  	if FollowRelationship.find_by(followed_user_id: params[:user_id], following_user_id: current_user.id).nil?
		following = current_user.active_follow_relationships.new(followed_user_id: params[:user_id])
		if following.save
			redirect_to lincoln_riders_user_path(params[:user_id])
		end
	else
		redirect_to lincoln_riders_user_path(params[:user_id])
	end
  end

  def destroy
  	if !(FollowRelationship.find_by(followed_user_id: params[:user_id], following_user_id:current_user.id).nil?)
	  	following = current_user.active_follow_relationships.find_by(followed_user_id: params[:user_id])
		if following.destroy
			redirect_to lincoln_riders_user_path(params[:user_id])
		end
	else
		redirect_to lincoln_riders_user_path(params[:user_id])
	end
  end
end
