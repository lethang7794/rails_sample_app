require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:harry)
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should redirect new when logged in" do
    log_in_as @user
    get login_url
    assert_redirected_to home_path
  end
end
