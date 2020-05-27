require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:harry)
  end

  test "reset password form" do
    ## Visit reset password form
    get new_password_reset_path
    assert_response :success
    assert_template 'password_resets/new'
    assert_select "input[name=?]", 'password_reset[email]'

    # Submit non existent email
    non_existent_email = "non_existent_email@example.com"
    post password_resets_path,
              params: { password_reset: { email: non_existent_email } }
    assert_not flash[:danger].empty?
    assert_template 'password_resets/new'

    # Submit existent email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not  flash[:info].empty?
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path

    ###
    ## Unsuccesfully visit change password form
    user = assigns(:user)
    flash_valid_user = "Invalid password reset link!"

    # Non existent email
    get edit_password_reset_url(user.reset_token, email: non_existent_email)
    assert_equal flash_valid_user, flash[:danger]
    assert_redirected_to root_path
    follow_redirect!
    get root_path
    assert flash.empty?

    # Existent email, not activated
    user.toggle!(:activated)
    get edit_password_reset_url(user.reset_token, email: non_existent_email)
    assert_equal flash_valid_user, flash[:danger]
    assert_redirected_to root_path
    follow_redirect!
    get root_path
    assert flash.empty?

    # Valid email, activated user, wrong token
    user.toggle!(:activated)
    get edit_password_reset_url("wrong-token", email: user.email)
    assert_equal flash_valid_user, flash[:danger]
    assert_redirected_to root_path
    follow_redirect!
    get root_path
    assert flash.empty?

    # Valid email, activated user, right token, expired reset password
    flash_password_reset_expired = "Password reset has expired. Please submit another password reset request."
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    get edit_password_reset_url(user.reset_token, email: user.email)
    assert_equal flash_password_reset_expired, flash[:danger]
    follow_redirect!
    get root_path
    assert flash.empty?

    ## Successfully visite change password form
    # Valid email, activated user, right token, not-expired reset password
    user.update_attribute(:reset_sent_at, 1.hours.ago)
    get edit_password_reset_url(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Password and password confirm not match
    patch password_reset_url(user.reset_token),
          params: { email:  user.email,
                    user:   { password:               "abcxyz",
                              password_confirmation:  "123456"} }
    assert_select '#error_explanation'

    # Password is blank
    patch password_reset_url(user.reset_token),
          params: { email:  user.email,
                    user:   { password:               "",
                              password_confirmation:  ""} }
    assert_select '#error_explanation'

    # Valid password and password_confirmation
    patch password_reset_url(user.reset_token),
          params: { email:  user.email,
                    user:   { password:               "newpassword",
                              password_confirmation:  "newpassword"} }
    assert is_logged_in?
    assert_not_equal user.reload.password_digest, @user.password_digest
    assert_equal "Password has been changed.", flash[:success]
    assert_redirected_to @user
    follow_redirect!
    get user_path(@user)
    assert flash.empty?
  end
end
