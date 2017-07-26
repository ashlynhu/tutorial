class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  # Public Methods

  # Index action protected by logged_in_user before filter
  def index
    @users = User.all
  end

  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])  # Find user by ID
    # If update contains strong parameters, then complete update successfully
    if @user.update_attributes(user_params)
      # Flash success message to UI to signify complete changes
      flash[:success] = "Profile updated"
      # Redirect the user to their personal page
      redirect_to @user
    # If update parameters were not strong, then re-render the edit form
    else
      render 'edit' 
    end
  end

  # Private methods
  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    # Before filters

    # Confirm a logged-in user
    # Only edit and update are filtered by this
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirm the correct user is logged in before edit and update
    def correct_user
      @user = User.find(params[:id])
      # Redirect to home page if user is not the current user and is trying to access
      # update and/or edit pages for another user
      redirect_to(root_url) unless current_user?(@user) 
    end

end
