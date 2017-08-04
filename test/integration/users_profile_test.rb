require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
  	@user = users(:michael)
  end

  test "profile display" do 
  	# 1 - Visit the user profile page
  	get user_path(@user)
  	assert_template 'users/show'
  	# 2 - Check that the user profile page has proper title
  	assert_select 'title', full_title(@user.name)
  	assert_select 'h1', text: @user.name
  	# 3 - Check that micropost count is appropriate
  	assert_match @user.microposts.count.to_s, response.body
  	assert_select 'div.pagination'
  	# 4 - Check for pagination
  	@user.microposts.paginate(page: 1).each do |micropost|
  		assert_match micropost.content, response.body
  	end
  end
end
