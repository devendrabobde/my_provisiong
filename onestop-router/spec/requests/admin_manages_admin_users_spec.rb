require 'spec_helper'

describe "AdminManagesAdminUsers" do
  subject { page }
  let(:admin_user) { FactoryGirl.create(:admin_user) }

  before do
    visit new_admin_user_session_path
    admin_user_email_login(admin_user)
    click_link "Admin Users"
  end

  describe "admin users display" do
    its(:current_path) { should == admin_admin_users_path }
    it "has exactly 5 columns" do
      should have_selector('table#admin_users.index th a', count: 5)
      should have_selector('table#admin_users.index th a', text: "User Name")
      should have_selector('table#admin_users.index th a', text: "Email")
      should have_selector('table#admin_users.index th a', text: "Current Sign In At")
      should have_selector('table#admin_users.index th a', text: "Last Sign In At")
      should have_selector('table#admin_users.index th a', text: "Sign In Count")
    end
    it { should have_link "New Admin User" }
  end

  describe "add a new admin user" do
    before { click_link "New Admin User" }
    its(:current_path) { should == new_admin_admin_user_path }

    context "the new user is legitimate" do
      before do
        fill_in "User name",                    with: "Nick-Hance"
        fill_in "Email",                        with: "test@example.com"
        fill_in "Password*",                    with: "password"
        fill_in "Password confirmation",        with: "password"
        check("Disabled")
        click_button "Create Admin user"
        @new_admin_user = AdminUser.find_by_user_name("Nick-Hance")
      end
      it "creates a disabled admin user" do
        should have_text "Admin user was successfully created"
        @new_admin_user.disabled.should be_true
      end
    end

    context "add a new admin with an existing username" do
      before do
        fill_in "User name",                    with: "#{admin_user.user_name}"
        fill_in "Email",                        with: "#{admin_user.email}"
        fill_in "Password*",                    with: "password"
        fill_in "Password confirmation",        with: "password"
        click_button "Create Admin user"
      end
      it "gives an error message" do
        should have_text "has already been taken. Try suggested usernames: #{admin_user.user_name}1, #{admin_user.user_name}2"
      end
    end
  end

  describe "edit existing admin user without changing the password" do
    before do
      visit admin_admin_users_path
      click_link "Edit"
      fill_in "User name",                  with: "Nick-Hance"
      click_button "Update Admin user"
    end
    it "gives a success message" do
      should have_text "Admin user was successfully updated."
    end
  end

  describe "view an existing admin user" do
    before do
      visit admin_admin_users_path
      click_link "View"
    end
    it "lists the admin's properties" do
      should have_text "#{admin_user.user_name}"
      should have_text "#{admin_user.email}"
      should have_text "Sign In Count"
      should have_text "Current Sign In At"
      should have_text "Last Sign In At"
      should have_text "Current Sign In Ip"
      should have_text "Last Sign In Ip"
      should have_text "Created At"
      should have_text "Updated At"
      should have_text "Disabled"
      should_not have_text "Encrypted Password"
      should_not have_text "Created Date As Number"
      should_not have_text "Comments"
    end
  end

  describe "filter admin users" do
    before { visit admin_admin_users_path }
    context "for non-existent admin" do
      before do
        fill_in "Search Email", with: "no results"
        click_button "Filter"
      end
      it "finds no admin users" do
        should have_text "No Admin Users found"
      end
    end

    context "for an existing admin" do
      before do
        fill_in "Search Email", with: "#{CUT_EMAIL.match(admin_user.email)[0].sub('@', '')}"
        click_button "Filter"
      end
      it "finds the admin users" do
        should have_text "#{admin_user.email}"
        should have_field('Search Email', with: "#{CUT_EMAIL.match(admin_user.email)[0].sub('@', '')}")
      end
    end
  end
end
