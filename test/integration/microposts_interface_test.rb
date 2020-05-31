require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @harry           = users(:harry)
    @ron             = users(:ron)
    @draco           = users(:draco)
    @harry_micropost = @harry.microposts.first
  end

  test "microposts interface" do
    # log in
    log_in_as @harry
    get root_url
    assert_template 'static_pages/home'

    # check the micropost pagination
    assert_select 'div.pagination'

    # make an invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_template 'static_pages/home'
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'

    # make a valid submission
    content = "An awesome new micropost"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content }}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # delete a post
    assert_select 'span.delete>a', text: 'delete'
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@harry_micropost)
    end

    # visit a second user’s page to make sure there are no “delete” links
    get user_path(@ron)
    assert_select 'a', text: 'delete', count: 0
  end

  test "sidebar micropost count" do
    # Old user
    log_in_as @harry
    get root_url
    harry_initial_microposts = @harry.microposts.count
    assert_match "#{harry_initial_microposts} microposts", response.body

    post microposts_path, params: {micropost: {content: "New Micrpost" } }
    get root_url
    assert_match "#{harry_initial_microposts + 1} microposts", response.body

    delete micropost_path(@harry_micropost)
    get root_url
    assert_match "#{harry_initial_microposts} microposts", response.body

    # Brand new user
    log_in_as @draco
    get root_url
    assert_match "0 microposts", response.body

    post microposts_path, params: { micropost: { content: "Another new micropost" } }
    get root_url
    assert_match "1 micropost", response.body

    post microposts_path, params: { micropost: { content: "Another new micropost" } }
    get root_url
    assert_match "2 microposts", response.body
  end
end
