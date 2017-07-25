require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",
  		password: "foobar", password_confirmation: "foobar")
  end

  # Test validity of user model instance
  test "should be valid" do
  	assert @user.valid?
  end

  # Test for presence of name attribute
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  # Test for presence of e-mail address
  test "email should be present" do 
  	@user.email = "    "
  	assert_not @user.valid?
  end

  # Validate length of name
  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  # Validate length of email attribute
  test "email should not be too long" do 
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  # Validate that email is correct format
  test "email validation should accept valid addresses" do 
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
    	@user.email = valid_address 
    	assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # Test email when given incorrect format
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # Test emails for uniqueness
  test "email addresses should be unique" do 
  	duplicate_user = @user.dup 					# Duplicate user with same email
  	duplicate_user.email = @user.email.upcase	# Test for uniqueness is case insensitive
  	@user.save									# Save original user
  	assert_not duplicate_user.valid?			# Assert that the duplicate user is not unique
  end

  # Test that email addresses are lowercase when saved
  test "email addresses should be saved as lower-case" do 
  	mixed_case_email = "Foo@ExAMPle.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # Enforce requirement that passwords are of minimum length and are not blank
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # Test authenticated with a non-existent digest
  test "authenticated? should return false for a user with a nil digest" do 
    assert_not @user.authenticated?('')
  end
end
