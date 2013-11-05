require 'spec_helper'

describe "AdminManagesIdentityServices" do
  subject { page }
  let(:admin_user)    { FactoryGirl.create(:admin_user) }
  let(:organization)  { FactoryGirl.create(:organization) }
  let(:ois)           { FactoryGirl.create(:ois) }

  before do
    visit new_admin_user_session_path
    admin_user_email_login(admin_user)
    organization.save
    ois.save
    click_link "Identity Services"
  end

  describe "list identity services" do
    it "has exactly 2 columns" do
      should have_selector('table#identity_services.index th a', count: 2)
      should have_selector('table#identity_services.index th a', text: "Identity Service Name")
      should have_selector('table#identity_services.index th a', text: "Ip Address Concat")
    end
  end

  describe "create a new identity service" do
    before do
      click_link "New Identity Service"
      fill_in "Identity Service Name",            with: "BuildBetterSoftware.com"
      fill_in "Identity Service password",        with: "12345678911234567892123456789312345678941234567895"
      fill_in "Ip address concat",                with: "10.1.1.1"
      fill_in "Outgoing service id",              with: "51"
      fill_in "Outgoing service password",        with: "secrets"
      fill_in "Enrollment url",                   with: "http://www.reenhanced.com/contact"
      fill_in "Authentication url",               with: "http://www.reenhanced.com/"
      fill_in "Idp level",                        with: "3"
      select "#{organization.organization_name}", from: "Organization"
      check("Disabled")
    end
    it "excludes some text" do
      should_not have_text "Created date"
      should_not have_text "Last update date"
      should_not have_text "Slug"
      should_not have_text "Created date as number"
      should_not have_text "Last update date as number"
    end
    it "saves the identity service" do
      click_button "Save"
      should have_text "was successfully created"
    end
  end

  describe "view identity service" do
    before { click_link "View" }
    it "shows ois data" do
      should have_text "#{ois.ois_name}"
      should have_text "Createddate"
      should have_text "Lastupdatedate"
      should have_text "Disabled"
      should_not have_text "Comments"
    end
  end

  describe "generate new password" do
    before do
      click_link "Edit"
      @previous_password = find_field("Identity Service password").value
    end
    it "generates a new password", js: true do
      click_button "Generate new password"
      click_link "Show Password"
      @new_password = find_field("Identity Service password").value
      @new_password.should_not be_blank
      @new_password.size.should be_between(50, 80)
      @new_password.should be_a_kind_of String
      @previous_password.should_not == find_field("Identity Service password").value
      click_button "Save"
      should have_text "was successfully updated"
      should have_text "#{@new_password}"
    end
  end

  describe "make password visible" do
    before do
      click_link "Edit"
    end
    it "masks the password if 'Show Password' is not clicked" do
      should have_field "Identity Service password", type: "password"
    end
    it "unmasks the password if 'Show Password' is clicked", js: true do
      click_link "Show Password"
      should have_field "Identity Service password", type: "text"
    end
  end

  describe "filter ois's" do
    it { should have_text "Search Ois name" }
    context "a non-existent ois" do
      before do
        fill_in "Search Ois name", with: "no results"
        click_button "Filter"
      end
      it { should have_text "No Identity Services found" }
    end
    context "an existing ois" do
      before do
        fill_in "Search Ois name", with: "#{CUT_TERM.match(ois.ois_name)[0].gsub(/[\s-]/, "")}"
        click_button "Filter"
      end
      it { should have_text "#{ois.ois_name}" }
    end
  end
end
