require 'spec_helper'

describe "AdminManagesOrganizations" do
  subject { page }
  let(:admin_user)    { FactoryGirl.create(:admin_user) }
  let(:organization)  { FactoryGirl.create(:organization) }

  before do
    visit new_admin_user_session_path
    admin_user_email_login(admin_user)
    organization.save
    click_link "Organizations"
  end

  describe "list organizations" do
    it "has exactly 4 columns" do
      should have_selector('table#organizations.index th a', count: 4)
      should have_selector('table#organizations.index th a', text: "Organization NPI")
      should have_selector('table#organizations.index th a', text: "Organization Name")
      should have_selector('table#organizations.index th a', text: "Contact First Name")
      should have_selector('table#organizations.index th a', text: "Contact Last Name")
    end
  end

  describe "add a new organization" do
    before do
      click_link "New Organization"
      fill_in "Organization npi",  with: "0123456789"
      fill_in "Organization name",  with: "BuildBetterSoftware.com"
      fill_in "Address1",  with: "312 West Broad Street"
      fill_in "Address2",  with: "n/a"
      fill_in "City",  with: "Quakertown"
      fill_in "State code",  with: "PA"
      fill_in "Postal code",  with: "18951"
      fill_in "First Name",  with: "Nicholas"
      fill_in "Last Name",  with: "Hance"
      fill_in "Phone",  with: "215.804.9408"
      fill_in "Email",  with: "nhance@reenhanced.com"
      check("Disabled")
    end
    it "excludes some text" do
      should_not have_text "Createddate"
      should_not have_text "Lastupdatedate"
      should_not have_text "Slug"
    end
    it "saves the organization" do
      click_button "Save"
      should have_text "was successfully created"
    end
  end

  describe "view an organization" do
    before { click_link "View" }
    it "shows the organization's data" do
      should have_text "#{organization.organization_name}"
      should have_text "Createddate"
      should have_text "Lastupdatedate"
      should_not have_text "Comments"
    end
  end

  describe "filter organizations" do
    context "a non-existent organization" do
      before do
        fill_in "Search Organization name", with: "no results"
        click_button "Filter"
      end
      it { should have_text "No Organizations found" }
    end
    context "an existing organization" do
      before do
        fill_in "Search Organization name", with: "#{CUT_TERM.match(organization.organization_name)[0].gsub(/[\s-]/, "")}"
        click_button "Filter"
      end
      it { should have_text "#{organization.organization_name}" }
    end
  end
end
