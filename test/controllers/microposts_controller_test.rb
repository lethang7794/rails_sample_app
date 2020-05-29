require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
    @micropost = @user.microposts.first
  end

  test "should redirect create if not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem Ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
