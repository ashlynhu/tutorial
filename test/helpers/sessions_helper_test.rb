require 'test_helper'

# => Test Sequence
# 1 -- Define user variable using fixtures
# 2 -- Call the remember method to remember the given user
# 3 -- Verify that current_user is equal to the given user

class SessionsHelperTest < ActionView::TestCase
	def setup
		@user = users(:michael)
		remember(@user)
	end

	
	test "current_user returns right user  when session is nil" do 
		assert_equal @user, current_user 	# User = current user
		assert is_logged_in?				# User is logged in
	end

	# Current user should be nill if user's remember digest doesnt correspond correctly to the remember token
	test "current_user returns nil when remember digest is wrong" do 
		@user.update_attribute(:remember_digest, User.digest(User.new_token)) 	# Update current user's remember digest
		assert_nil current_user 	# Current user should be nil
	end
end