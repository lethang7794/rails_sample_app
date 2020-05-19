module SessionsHelper

	# Log in the given user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Remembers a user in a persistent session.
	def remember(user)
		user.remember
		cookies.permanent.encrypted[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Return the current user (if any)
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		end
	end

	# Return true if user is logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	# Log out the current user
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end
end
