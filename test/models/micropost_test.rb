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
end
