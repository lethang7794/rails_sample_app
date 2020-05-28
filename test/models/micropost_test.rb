require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:harry)
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
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
    more_than_140 = "a" * 141
    @micropost.content = more_than_140
    assert_not @micropost.valid?
  end
end
