module SessionsHelper

	# Log in user
	def log_in(user)
		# Places a cookie on user's browser so id can be retrieved on subsequent pages
		session[:user_id] = user.id
	end

	# Remembers user for a period of time in a persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id 
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Returns true if the given user is the current user
	# Returns false if the given user is not the current user
	def current_user?(user)
		user == current_user
	end

	# Return instance of the current logged in user, if one exists
	# corresponding to the remember token cookie
	def current_user
		if (user_id = session[:user_id])	
			@current_user ||= User.find_by(id: user_id) # Current user or find user and assign to current user
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Returns true if the user if logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	# Forgets the current user's persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Logs out the current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
