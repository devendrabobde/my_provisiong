module LoginHelper
  def admin_user_email_login(admin_user)
		fill_in "admin_user[login]",    with: admin_user.email
    fill_in "admin_user[password]", with: admin_user.password
    click_button "Login"
  end

  def admin_user_name_login(admin_user)
    fill_in "admin_user[login]",      with: admin_user.user_name
    fill_in "admin_user[password]",   with: admin_user.password
    click_button "Login"
  end
end