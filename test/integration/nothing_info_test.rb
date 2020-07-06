require 'test_helper'

class NothingInfoTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
    @user_with_no_microposts = users(:hermione)
    @user_with_no_following = users(:ron)
    @user_with_no_followers = users(:draco)
    @user_with_no_feed_items = users(:brand_new)
  end

  # Another's pages
  test "should show correct content when visit another user show page without any microposts as a non logged in user" do
    get user_path(@user_with_no_microposts)
    assert_match "#{@user_with_no_microposts.name} hasn't posted any micropost yet", response.body
    assert_match "When they post a micropost, it’ll show up here.", response.body
  end

  test "should show correct content when visit another user show page without any microposts as a logged in user" do
    log_in_as @harry
    get user_path(@user_with_no_microposts)
    assert_match "#{@user_with_no_microposts.name} hasn't posted any micropost yet", response.body
    assert_match "When they post a micropost, it’ll show up here.", response.body
  end

  test "should show correct content when visit another user media page without any photos as a logged in user" do
    log_in_as @harry
    get media_user_path(@user_with_no_microposts)
    assert_match "#{@user_with_no_microposts.name} hasn't posted any photos yet", response.body
    assert_match "When they post a micropost with photos, it’ll show up here.", response.body
  end

  test "should show correct content when visit another user following page without any following as a logged in user" do
    log_in_as @harry
    get following_user_path(@user_with_no_following)
    assert_match "#{@user_with_no_following.name} isn't following anyone yet", response.body
    assert_match "When they do, they’ll be listed here.", response.body
  end

  test "should show correct content when visit another user followers page without any followers as a logged in user" do
    log_in_as @harry
    get followers_user_path(@user_with_no_followers)
    assert_match "#{@user_with_no_followers.name} doesn't have any followers yet", response.body
    assert_match "When someone follows them, they’ll be listed here.", response.body
  end

  # Own page
  test "should show correct content when visit user own show page without any microposts" do
    log_in_as @user_with_no_microposts
    get user_path(@user_with_no_microposts)
    assert_match "You haven’t posted any micropost yet", response.body
    assert_match "When you post a micropost, it’ll show up here.", response.body
    assert_select 'a[href=?]', home_path, text: "Post a micropost now"
  end

  test "should show correct content when visit user own media page without any photo" do
    log_in_as @user_with_no_microposts
    get media_user_path(@user_with_no_microposts)
    assert_match "You haven’t posted any photos yet", response.body
    assert_match "When you post a micropost with photos, it’ll show up here.", response.body
    assert_select 'a[href=?]', home_path, text: "Post a photo now"
  end

  test "should show correct content when visit user own following page without any following" do
    log_in_as @user_with_no_following
    get following_user_path(@user_with_no_following)
    assert_match "You don't following anyone yet", response.body
    assert_match "When you do, they’ll be listed here and you'll see their microposts in your timeline.", response.body
    assert_select 'a[href=?]', users_path, text: "Find people to follow"
  end

  test "should show correct content when visit user own followers page without any followers" do
    log_in_as @user_with_no_followers
    get followers_user_path(@user_with_no_followers)
    assert_match "You don't have any followers yet", response.body
    assert_match "When someone follows you, you'll see them here.", response.body
  end

  test "should show correct content in feeds when there isn't any feed items" do
    log_in_as @user_with_no_feed_items
    get home_path
    assert_match "Welcome to Sample App!", response.body
    assert_match "This is the worst place to see what’s happening in the world. By the way, find some people to follow now.", response.body
    assert_select 'a[href=?]', users_path, text: "Find people to follow"
  end
end
