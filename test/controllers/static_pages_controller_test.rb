require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
  end

  test "should get root when not logged in" do
    get root_path
    assert_response :success
  end

  test "should redirect root when logged in" do
    log_in_as @harry
    get root_path
    assert_redirected_to home_path
  end

  test "should redirect home when not logged in" do
    get home_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should get home for logged user" do
    log_in_as @harry
    get home_path
    assert_response :success
    assert_select "title", "Home | Sample App"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Sample App"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | Sample App"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Sample App"
  end
end
