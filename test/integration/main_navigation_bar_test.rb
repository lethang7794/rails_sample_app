require 'test_helper'

class MainNavigationBarTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
  end

  test "brand logo and home nav-item should point to root when not logged in" do
    get root_url
    assert_select "a[href=?]", root_path, count: 2
  end

  test "brand logo should point to home when logged in" do
    log_in_as @harry
    get home_url
    assert_select "a[href=?]", home_path, count: 1
  end
end
