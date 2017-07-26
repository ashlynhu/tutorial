require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
		@other_user = users(:archer)
	end

  # Protect index page from unauthorized access
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  	test "should get new" do
    	get signup_path
    	assert_response :success
  	end

  	test "should redirect edit when not logged in" do
  		get edit_user_path(@user)
  		# Assert that an error message occurs
  		assert_not flash.empty?
  		# Assert that user is redirected to login screen
  		assert_redirected_to login_url 
  	end

  	test "should redirect update when not logged in" do 
  		patch user_path(@user), params: { user: {
  			name: @user.name,
  			email: @user.email
  			}}
  		# Assert error message occurs
  		assert_not flash.empty?
  		# Assert that user is redirected to login screen
  		assert_redirected_to login_url
  	end

  	test "should redirect edit when logged in as wrong user" do 
  		# Log in as second user
  		log_in_as(@other_user)
  		# Try to access edit path of first user
  		get edit_user_path(@user)
  		# Assert that there is a warning sign
  		assert flash.empty?
  		# Assert that the second user is redirected to the home page
  		assert_redirected_to root_url
  	end

  	test "should redirect update when logged in as wrong user" do 
  		# Log in as second user
  		log_in_as(@other_user)
  		# Try to access the update information of the first user
  		patch user_path(@user), params: { user: {
  			name: @user.name,
  			email: @user.email
  			}}
  		# Assert that the second user is shown a warning message
  		assert flash.empty?
  		# Assert that the second user is redirected to the home page
  		assert_redirected_to root_url
  	end

end
