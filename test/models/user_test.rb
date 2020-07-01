require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Barack Obama",
      username: "BarackObama",
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

  test "username should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = "a_valid_email@example.com"
    @user.save
    assert_not duplicate_user.valid?
  end

  test "username should not be too long" do
    @user.username = "a" * 21
    assert_not @user.valid?
  end

  test "username validation should accept valid username" do
    valid_usernames = %w[
      user
      user12345
      123456789
    ]

    valid_usernames.each do |valid_username|
      @user.username = valid_username
      assert @user.valid?, "#{valid_username.inspect} should be valid"
    end
  end

  test "username validation should not accept invalid username" do
    invalid_usernames = %w[
      user@12345
      user.12345
      user_12345
      user-12345
    ]
    invalid_usernames += ["user 123"]

    invalid_usernames.each do |invalid_username|
      @user.username = invalid_username
      assert @user.invalid?, "#{invalid_username.inspect} should be invalid"
    end
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

  test "bio should not be too long" do
    @user.bio = "a" * 201
    assert_not @user.valid?
  end

  test "authenticated should return false for a user with nil remember_digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow" do
    Relationship.delete_all

    harry = users(:harry)
    ron = users(:ron)
    assert_not harry.following?(ron)

    harry.follow(ron)
    assert harry.following?(ron)
    assert ron.followers.include?(harry)

    harry.unfollow(ron)
    assert_not harry.following?(ron)
  end

  test "feed should have the right posts" do
    @harry = users(:harry)
    @ron   = users(:ron)
    @draco = users(:draco)

    @harry.microposts.each do |post_self|
      assert @harry.feed.include?(post_self)
    end

    @ron.microposts.each do |post_following|
      assert @harry.feed.include?(post_following)
    end

    @draco.microposts.each do |post_unfollowing|
      assert_not @harry.feed.include?(post_unfollowing)
    end
  end
end
