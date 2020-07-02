require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
    @other_user = users(:ron)
    @not_activated_user = users(:hermione)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect new when logged in" do
    log_in_as @user
    get signup_path
    assert_redirected_to home_path
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: 'password',
                                                    password_confirmation: 'password',
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  test 'should redirect destroy when NOT LOGGED IN' do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy when logged in as a NON-ADMIN user' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to root_path
  end

  test 'should redirect index when not activated' do
    log_in_as(@not_activated_user)
    get users_path
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash[:warning].empty?
  end

  test 'should redirect update when not activated' do
    log_in_as(@not_activated_user)
    get edit_user_path(@not_activated_user)
    new_name = "A New Name"
    patch user_path(@not_activated_user), params: { user: { name: new_name } }
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash[:warning].empty?
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to @user
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to @user
  end

  test "should redirect media when not logged in" do
    get media_user_path(@user)
    assert_redirected_to @user
  end

  test "param username should be case-insensitive for show" do
    get "/#{@user.username.swapcase}"
    assert_response :success
  end

  test "param username should be case-insensitive for media" do
    log_in_as @user
    get "/#{@user.username.swapcase}/media"
    assert_response :success
  end

  test "param username should be case-insensitive for following" do
    log_in_as @user
    get "/#{@user.username.swapcase}/following"
    assert_response :success
  end

  test "param username should be case-insensitive for followers" do
    log_in_as @user
    get "/#{@user.username.swapcase}/followers"
    assert_response :success
  end

  test "param username should be case-insensitive for edit" do
    log_in_as @user
    get "/#{@user.username.swapcase}/edit"
    assert_response :success
  end
end
