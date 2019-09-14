class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
		case resource

		when Admin
		when User
			lincoln_riders_user_mypage_posts_path
		end
	end

	def after_sign_out_path_for(resource)
		case resource

		when Admin
		when User
		end
	end
end
