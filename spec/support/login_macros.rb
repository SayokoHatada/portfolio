module LoginMacros
  def login_as(user)
    visit login_path
    fill_in "email", with: user.email
    fill_in "password", with: "password123"
    click_button "Login"

    puts page.body if current_path != diaries_path
  end
end
