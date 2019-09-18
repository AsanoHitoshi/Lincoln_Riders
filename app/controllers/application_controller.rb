class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
		case resource

		when Admin then
			lincoln_riders_root_path
		when User then
			lincoln_riders_user_mypage_posts_path
		end
	end

	def after_sign_out_path_for(resource)
		case resource

		when Admin then
			lincoln_riders_root_path

		when User then
			lincoln_riders_root_path
		end
	end
end
