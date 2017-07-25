class SessionsController < ApplicationController
  def new
  end

  def create
  	# user = user with email = session[email]
  	user = User.find_by(email: params[:session][:email].downcase)
  	# If user exists and is authenticated, continue the log in process
  	if user && user.authenticate(params[:session][:password])
      log_in(user)  # Call log_in helper method
      remember user   # Will assign user a permanent cookie until logout
      redirect_to user
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
