require 'test_helper'

class MiniNavbarTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
    log_in_as @user
  end

  test "should show home in /home" do
    get home_url
    assert_select '#mini-bar-heading', text: "Home"
  end

  test "should show in pages with query string" do
    get home_url + "?page=2"
    assert_select '#mini-bar-heading', text: "Home"

    get user_path(@user) + "?page=2"
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.microposts.count} microposts"
  end

  test "should show correct content in user show/media page" do
    get user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.microposts.count} microposts"

    get media_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.media.count} photos"
  end


  test "should show correct content in show page when params[:username] is not case-match" do
    get user_path(@user).upcase
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.microposts.count} microposts"

    get user_path(@user).downcase
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.microposts.count} microposts"

    get user_path(@user).swapcase
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "#{@user.microposts.count} microposts"
  end

  test "should show correct content when user doesn't exist" do
    @user = User.new(username: "abc123xyz")

    get user_path(@user)
    assert_select '#mini-bar-heading', text: "Profile"

    get media_user_path(@user)
    assert_select '#mini-bar-heading', text: "Profile"

    get following_user_path(@user)
    assert_select '#mini-bar-heading', text: "Profile"

    get followers_user_path(@user)
    assert_select '#mini-bar-heading', text: "Profile"
  end

  test "should show correct content in user following/followers page" do
    get following_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "@#{@user.username}"

    get followers_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "@#{@user.username}"
  end

  test "should show correct content in users index page" do
    get users_path
    assert_select '#mini-bar-heading', text: "Explorer"
    assert_select '#mini-bar-detail', text: "Let's follow other people"
  end

  test "should show correct content in user edit page" do
    get edit_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '#mini-bar-detail', text: "Edit profile"
  end
end
