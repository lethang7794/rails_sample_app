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
    assert_difference '@harry.following.count', 1 do
      assert_difference '@ron.followers.count', 1 do
        post relationships_path, params: { followed_id: @ron.id }
      end
    end
  end

  test "should unfollow a user the standard way" do
    Relationship.delete_all
    @harry.follow(@ron)
    relationship = @harry.active_relationships.find_by(followed_id: @ron.id)
    assert_difference '@harry.following.count', -1 do
      assert_difference '@ron.followers.count', -1 do
        delete relationship_path(relationship)
      end
    end
  end

  test "should follow a user the Ajax way" do
    Relationship.delete_all
    assert_difference '@harry.following.count', 1 do
      assert_difference '@ron.followers.count', 1 do
        post relationships_path, xhr: true, params: { followed_id: @ron.id }
      end
    end
  end

  test "should unfollow a user the Ajax way" do
    Relationship.delete_all
    @harry.follow(@ron)
    relationship = @harry.active_relationships.find_by(followed_id: @ron.id)
    assert_difference '@harry.following.count', -1 do
      assert_difference '@ron.followers.count', -1 do
        delete relationship_path(relationship), xhr: true
      end
    end
  end
end
