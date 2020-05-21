require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
  end

  test 'should show edit form after an unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'not_an_email',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors:'
  end

  test "friendly forwarding followed by a successfull edit" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)

    new_name = "Foo Bar"
    new_email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: new_name,
                                              email: new_email,
                                              password: '',
                                              password_confirmation: '' } }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end
end
