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

  test "should have enoung tab link" do
    log_in_as @harry
    get user_path(@ron)
    assert_select ".tab-link", count: 2
  end

  test "should have tab link for show and media" do
    log_in_as @harry
    get user_path(@ron)
    assert_select ".show-link[href= ?]",  user_path(@ron),        count: 1, text: "Microposts"
    assert_select ".media-link[href= ?]", media_user_path(@ron),  count: 1, text: "Media"
  end

  test "media link should respond to Ajax request correctly" do
    log_in_as @harry
    get user_path(@ron)
    assert_select '#mini-bar-heading', text: "#{@ron.name}"
    assert_select '#mini-bar-detail', text: "1 micropost"

    get media_user_path(@ron), xhr: true
    get media_user_path(@ron), xhr: true # 2 times to prevent error in second times.

    # Page title
    assert_match full_title("Media microposts from #{@ron.name} (@#{@ron.username})"), @response.body

    # Page url
    assert_match media_user_path(@ron), @response.body

    # Mini-navbar
    assert_match "0 photo", @response.body

    # Microposts
    assert_match "#{@ron.name} hasn\\'t posted any photos yet", @response.body
    assert_match "When they post a micropost with photos, it’ll show up here.", @response.body
  end

   test "show link should respond to Ajax request correctly" do
    log_in_as @harry
    get media_user_path(@ron)
    assert_select '#mini-bar-heading', text: "#{@ron.name}"
    assert_select '#mini-bar-detail', text: "0 photos"

    get user_path(@ron), xhr: true
    get user_path(@ron), xhr: true # 2 times to prevent error in second times.

    # Page title
    assert_match full_title("#{@ron.name} (@#{@ron.username})"), @response.body

    # Page url
    assert_match user_path(@ron), @response.body

    # Mini-navbar
    assert_match "1 micropost", @response.body

    # Microposts
    assert_match @ron.microposts.first.content, @response.body
  end
end
