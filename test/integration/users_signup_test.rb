require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	# Tests to be sure no changes to database if invalid user is created
  	test "invalid signup information" do
    	get signup_path
    	assert_no_difference 'User.count' do
      		post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    	end
    	assert_template 'users/new'
  	end

  	# Test validating that a user was added to database after signing up
  	test "Valid signup information" do 
  		get signup_path
  		# Assert that the user count is different by one after inserting user
  		assert_difference 'User.count', 1 do
  			post users_path, params: { user: {name: "Example User",
  					email: "user@example.com",
  					password: "password",
  					password_confirmation: "password"}
  			}
  		end
  		follow_redirect!	# Redirect page
  		assert_template 'users/show'	# Confirm correct template
      assert is_logged_in?
  	end
end
