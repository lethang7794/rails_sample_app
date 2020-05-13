require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Barack Obama",
      email: "barack@obama.com",
      password: "alpine",
      password_confirmation: "alpine"
    )
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

  test "email validation should accept valid emails" do
    valid_emails = %w[
      user@example.com
      foo-not_bar@foo.bar.COM
      foo+bar@123.com
    ]

    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "email validation should not accept invalid emails" do
    invalid_emails = %w[
      user@example,com
      user@example..com
      user_at_example.com
      user@example
      user@more_example.com
      user@more+more.example.com
    ]

    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcase before save" do
    mix_case_email = "FooBar@eXaMpLe.cOm"
    @user.email = mix_case_email
    @user.save
    assert_equal mix_case_email.downcase, @user.reload.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passworld should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
