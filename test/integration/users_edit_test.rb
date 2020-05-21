require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
  end

  test 'should show edit form after an unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: 'not_an_email',
                                       password: 'foo', password_confirmation: 'bar' }}
    assert_template 'users/edit'
  end
end
