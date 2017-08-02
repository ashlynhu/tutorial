class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	# 1) Find user by email address
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		# Update attributes with password reset token and sent timestamp
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		# Flash message
  		flash[:info] = "Email sent with password reset instructions"
  		# Redirect to home page
  		redirect_to root_url
  	else
  		# Inform user that email address was not found
  		flash.now[:danger] = "Email address not found"
  		render 'new'
  	end
  end

  def edit
  end
end
