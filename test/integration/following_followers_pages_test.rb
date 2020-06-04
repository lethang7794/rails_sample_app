require 'test_helper'

class FollowingFollowersPagesTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
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
end
