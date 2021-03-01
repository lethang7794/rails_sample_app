require "application_system_test_case"

class MicropostsInterfacesTest < ApplicationSystemTestCase
  setup do
    @user = users(:harry)
  end

  test "microposts interface" do
    visit login_url
    fill_in 'session_email', with: @user.email
    fill_in 'session_password', with: 'password'
    click_on 'commit'

    expect(page).to have_selector(:css, "div.pagination", wait: 3) 
  end
end
