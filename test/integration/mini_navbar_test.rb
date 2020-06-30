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

  test "should show correct content in user show/media page" do
    get user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '.detail', text: "#{@user.microposts.count} microposts"

    get media_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '.detail', text: "#{@user.media.count} photos"
  end

  test "should show correct content in user following/followers page" do
    get following_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '.detail', text: "@#{@user.username}"

    get followers_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '.detail', text: "@#{@user.username}"
  end

  test "should show correct content in users index page" do
    get users_path
    assert_select '#mini-bar-heading', text: "Explorer"
    assert_select '.detail', text: "Let's follow other people"
  end

  test "should show correct content in user edit page" do
    get edit_user_path(@user)
    assert_select '#mini-bar-heading', text: "#{@user.name}"
    assert_select '.detail', text: "Edit profile"
  end
end
