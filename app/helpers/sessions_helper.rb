module SessionsHelper

	# Log in the given user
	def log_in(user)
		session[:user_id] = user.id
	end
end
