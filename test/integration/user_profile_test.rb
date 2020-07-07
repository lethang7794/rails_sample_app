require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @harry = users(:harry)
    @ron  = users(:ron)
  end

  test "user profile" do
    get user_path(@harry)
    assert_template 'users/show'

    assert_select 'title', { count: 1},
                  "More than one title."
    assert_select 'title', { text: full_title("#{@harry.name} (@#{@harry.username})")},
                  "Wrong title."

    assert_select 'h1', text: @harry.name
    assert_select '.user_avatar>img.gravatar'

    assert_select 'div.detail', text: "#{@harry.microposts.count} microposts"

    assert_select 'div.pagination', count: 1

    @harry.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end

    log_in_as @harry
    get user_path(@harry)
    assert_select "#following_of_#{@harry.id}"
    assert_select "#followers_of_#{@harry.id}"
  end
  end
end
