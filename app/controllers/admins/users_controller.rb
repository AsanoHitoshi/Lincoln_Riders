class Admins::UsersController < ApplicationController
	before_action :authenticate_admin!

	PER=10

	def index
		@users = User.all.order(id: "ASC").page(params[:page]).per(PER)
	end

	def show
		@user = User.find_by(id: params[:id])
	end

	def destroy
		@user = User.find_by(id: params[:id])
		if @user.destroy
			redirect_to admins_users_path
		else
			redirect_to admins_user_path(@user)
		end
	end

end
