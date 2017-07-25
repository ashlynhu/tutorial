module SessionsHelper

	# Log in user
	def log_in(user)
		# Places a cookie on user's browser so id can be retrieved on subsequent pages
		session[:user_id] = user.id
	end

	# Return instance of the current logged in user, if one exists
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])	# Notice the OR-Equals operator
	end

	# Returns true if the user if logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	# Logs out the current user
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end
end
