require 'test_helper'

class FollowingFollowersPagesTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
    @ron   = users(:ron)
    log_in_as @harry
  end

  test "following page" do
    get following_user_path(@harry)
    assert_not @harry.following.empty?
    assert_match @harry.following.count.to_s, response.body
    @harry.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@harry)
    assert_not @harry.followers.empty?
    assert_match @harry.followers.count.to_s, response.body
    @harry.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test "should follow a user the standard way" do
    Relationship.delete_all
    assert_difference -> { @harry.following.count } => 1, -> { @ron.followers.count } => 1 do
      post relationships_path, params: { followed_id: @ron.id }
    end
  end

  test "should unfollow a user the standard way" do
    Relationship.delete_all
    @harry.follow(@ron)
    relationship = @harry.active_relationships.find_by(followed_id: @ron.id)
    assert_difference -> { @harry.following.count } => -1, -> { @ron.followers.count } => -1 do
      delete relationship_path(relationship)
    end
  end

  test "should follow a user the Ajax way" do
    Relationship.delete_all
    assert_difference -> { @harry.following.count } => 1, -> { @ron.followers.count } => 1 do
      post relationships_path, xhr: true, params: { followed_id: @ron.id }
    end
  end

  test "should unfollow a user the Ajax way" do
    Relationship.delete_all
    @harry.follow(@ron)
    relationship = @harry.active_relationships.find_by(followed_id: @ron.id)
    assert_difference -> { @harry.following.count } => -1, -> { @ron.followers.count } => -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test "should show feed in homepage for logged in user" do
    get home_path
    @harry.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end

    test "pagination should work in following page" do
    Relationship.delete_all
    
    celebrity = User.first # Fisrt user in database
    log_in_as celebrity

    users = User.all
    following = users[1..34]  # Test database only has 34 other users.
    following.each { |followed|
      assert_difference -> { celebrity.following.count } => 1, -> { followed.followers.count } => 1 do
        post relationships_path, params: { followed_id: followed.id }
      end
    }

    assert_equal 34, celebrity.following.count

    get following_user_path(celebrity)
    celebrity.following.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
    get following_user_path(celebrity) + "?page=2"
    celebrity.following.paginate(page: 2).each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test "pagination should work in followers page" do
    Relationship.delete_all

    celebrity = User.first # Fisrt user in database

    users = User.all
    followers = users[1..34] # Test database only has 34 other users.

    followers.each { |follower|
      log_in_as follower
      assert_difference -> { follower.following.count } => 1, -> { celebrity.followers.count } => 1 do
        post relationships_path, params: { followed_id: celebrity.id }
      end
    }

    assert_equal 34, celebrity.followers.count

    get followers_user_path(celebrity)
    celebrity.followers.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
    get followers_user_path(celebrity) + "?page=2"
    celebrity.followers.paginate(page: 2).each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end
