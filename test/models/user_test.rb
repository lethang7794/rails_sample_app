require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Barack Obama", email: "barack@obama.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ''
    assert_not @user.valid?
    @user.name = '         '
    assert_not @user.valid?
    @user.name = "\n"
    assert_not @user.valid?
    @user.name = "\n\n      \n"
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ''
    assert_not @user.valid?
    @user.email = '         '
    assert_not @user.valid?
    @user.email = "\n"
    assert_not @user.valid?
    @user.email = "\n\n      \n"
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end
