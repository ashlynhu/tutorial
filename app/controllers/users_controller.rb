class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # Public Methods

  # Index action protected by logged_in_user before filter
  def index
    @users = User.paginate(page: params[:page])
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
      @user.send_activation_email   # Method located in the user model
  		flash[:info] = "Please check email"
      redirect_to root_url
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

  # Find corresponding user and destroys it.
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url   # Redirect to the user's index
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

    # Confirms user is an admin which restricts destroy action to admins only
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
