class SessionsController < ApplicationController
  def new
  end

  def create
  	# user = user with email = session[email]
  	user = User.find_by(email: params[:session][:email].downcase)
  	# If user exists and is authenticated, continue the log in process
  	if user && user.authenticate(params[:session][:password])
      # Only allow users to log in if their account is activated
      if user.activated?
        log_in(user)  # Call log_in helper method
        # If remember box is checked --> remember the user
        # Otherwise --> forget the user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
      # Display error message
  		flash.now[:danger] = "Invalid email/password combination"
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
