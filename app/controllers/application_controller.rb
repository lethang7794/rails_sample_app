class ActionController::Base
	include SessionsHelper
end

class ApplicationController < ActionController::Base
	include SessionsHelper
	
	private
		# Checks if a user is logged in.
		def logged_in_user
			unless logged_in?
				flash[:danger] = "Please log in before access that page!"
				store_location
				redirect_to login_path
			end
		end
end
