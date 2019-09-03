class ApplicationController < ActionController::Base

	def after_sign_in_path_for(resource)
		case resource

		when Admin
		when User
			lincoln_riders_user_mypage_path
		end
	end
end
