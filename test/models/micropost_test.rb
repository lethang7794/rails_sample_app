require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:harry)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user_id should be presence" do
  	@micropost.user_id = nil
  	assert_not @micropost.valid?
  end

  test "content shoud be presence" do
    @micropost.content = nil
    assert_not @micropost.valid?
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    more_than_281 = "a" * 281
    @micropost.content = more_than_281
    assert_not @micropost.valid?
  end

  test "should be in most recent first order" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
