require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'should not create new user with invalid signup info' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: 'New User',
                                         email: 'new@user.com',
                                         password: '1',
                                         password_confirmation: '2' } }
    end

    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account activation' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: '123456',
                                         password_confirmation: '123456' } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)
    assert_not user.activated?

    assert_redirected_to user
    follow_redirect!
    assert_template 'users/show'

    # Test the flash message
    assert_not flash[:info].empty?
    assert is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("Invalid Token", email: user.email)
    get users_path
    assert_redirected_to root_url

    # Valid token, invalid email
    get edit_account_activation_path(user.activation_token, email: "Invalid Email")
    get users_path
    assert_redirected_to root_url

    # Vadid token/email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_redirected_to user
  end
end
