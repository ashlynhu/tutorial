class AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		# !user.authenticated? is an extra bool to prevent code from activating users
		# who have already been activated as an security measures
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			# If all conditions are meant, then the user should be updated to
			# be active
			user.activate 	# Method found in the user model responsible for activating users
			log_in user
			flash[:success] = "Account Activated!"
			redirect_to user 	# Redirect to user account if successful
		else
			flash[:danger] = "Invalid activation link"
			redirect_to root_url 	# Redirect to homepage if unsuccessful
		end
	end
end
