class LincolnRiders::FollowRelationshipsController < ApplicationController
	before_action :authenticate_user!
  def create
	following = current_user.active_follow_relationships.new(followed_user_id: params[:user_id])
	if following.save
		redirect_to lincoln_riders_user_mypage_posts_path
	else
	end
  end

  def destroy
  	following = current_user.active_follow_relationships.find_by(followed_user_id: params[:user_id])
	if following.destroy
		redirect_to lincoln_riders_user_mypage_posts_path
	else
	end
  end
end
