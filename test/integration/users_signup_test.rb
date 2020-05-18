require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test 'should create new user with valid signup info' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: '123456',
                                         password_confirmation: '123456' } }
    end

    follow_redirect!
    assert_template 'users/show'

    # Test the flash message
    assert_not flash[:success].empty?
    assert is_logged_in?
  end
end
