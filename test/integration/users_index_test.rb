require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @non_admin = users(:ron)
  end

  test "index page as non-admin including pagination" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2

    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a', text: 'delete', count: 0
    end
  end
end
