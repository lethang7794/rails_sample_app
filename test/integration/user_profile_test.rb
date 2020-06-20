require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:harry)
  end

  test "user profile" do
    get user_path(@user)
    assert_template 'users/show'

    assert_select 'title', { count: 1},
                  "More than one title."
    assert_select 'title', { text: full_title(@user.name)},
                  "Wrong title."

    assert_select 'h1', text: @user.name
    assert_select '.user_avatar>img.gravatar'

    assert_select 'h3>span', count: 1, text: @user.microposts.count.to_s

    assert_select 'div.pagination', count: 1

    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end

    log_in_as @user
    get home_path
    assert_select "#following_of_#{@user.id}"
    assert_select "#followers_of_#{@user.id}"
  end
end
