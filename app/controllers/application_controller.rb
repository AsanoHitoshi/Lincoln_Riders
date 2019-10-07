class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
		case resource

		when Admin then
			admins_root_path
		when User then
			lincoln_riders_user_mypage_path
		end
	end

	def after_sign_out_path_for(resource)
		case resource

		when :admin then
			lincoln_riders_root_path
		when :user then
			lincoln_riders_root_path
		end
	end

end
