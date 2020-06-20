require 'test_helper'

class PageTitlesTest < ActionDispatch::IntegrationTest
  def setup
    @harry = users(:harry)
  end

  test "Home page titles" do
    get root_path
    assert_select 'title', full_title

    log_in_as(@harry)
    get home_path
    assert_select 'title', full_title('Home')
  end

  test "Users's page titles" do
    log_in_as(@harry)

    get user_path(@harry)
    assert_select 'title', full_title(@harry.name)

    get media_user_path(@harry)
    assert_select 'title', full_title("Media microposts from #{@harry.name}")

    get following_user_path(@harry)
    assert_select 'title', full_title("People following #{@harry.name}")

    get followers_user_path(@harry)
    assert_select 'title', full_title("People followed by #{@harry.name}")
  end
end
