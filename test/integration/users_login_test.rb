require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
  end

  test "login with valid email and invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: "" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash[:danger].empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: "password"} }
    assert_redirected_to root_path
    follow_redirect!
    assert is_logged_in?
    assert_template 'static_pages/_home_logged_in'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_redirected_to root_path

    # Simulates an logout from a second tab in the same browser
    delete logout_path

    follow_redirect!
    assert_not is_logged_in?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering me" do
    log_in_as(@user, remember_me: '1')
    assert_equal assigns(:user).remember_token, cookies[:remember_token]
  end

  test "login with remembering me then login without remembering me" do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

  test "first time login without remembering me" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies[:remember_token]
  end
end
