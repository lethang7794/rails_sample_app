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
end
