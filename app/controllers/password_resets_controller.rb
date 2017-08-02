class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Check if password reset is expired 

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

  def update
    if params[:user][:password].empty?  # Do not update to empty password
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)  # Successful update
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'   # Failed update due to invalid password
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirm a valid user using generalized authenticated method
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Check expiration of reset token
    def check_expiration
      if @user.password_reset_expired?  # Token will expire 2 hours after it was sent
        flash[:danger] = "Password reset has expired"
        redirect_to new_password_reset_url
      end
    end

end
