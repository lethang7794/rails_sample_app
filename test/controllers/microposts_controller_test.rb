require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @harry           = users(:harry)
    @harry_micropost = @harry.microposts.first
    @ron             = users(:ron)
  end

  test "should redirect create if not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem Ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@harry_micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if micropost is someone's else" do
    log_in_as @ron
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@harry_micropost)
    end
    assert_redirected_to root_url
  end
end
