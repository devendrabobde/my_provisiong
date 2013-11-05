require 'spec_helper'

describe "AdminManagesPreferences" do
  subject { page }
  let(:admin_user)            { FactoryGirl.create(:admin_user) }
  let(:ois_client_preference) { FactoryGirl.create(:ois_client_preference) }

  before do
    visit new_admin_user_session_path
    admin_user_email_login(admin_user)
    ois_client_preference.save
    click_link "Preferences"
  end

  describe "list ois_client_preferences" do
    it "has exactly 4 columns" do
      should have_selector('table#preferences.index th a', count: 4)
      should have_selector('table#preferences.index th a', text: "Preference Name")
      should have_selector('table#preferences.index th a', text: "Faq Url")
      should have_selector('table#preferences.index th a', text: "Help Url")
      should have_selector('table#preferences.index th a', text: "Logo Url")
    end
  end

  describe "add new preferences" do
    before do
      click_link "New Preferences"
      fill_in "Preference name",  with: "Reenhanced LLC"
      fill_in "Faq url",  with: "http://www.reenhanced.com/faq"
      fill_in "Help url", with: "http://www.reenhanced.com/help"
      fill_in "Logo url", with: "http://www.reenhanced.com/images/logo.png"
    end
    it "excludes some text" do
      should_not have_text "Createddate"
      should_not have_text "Lastupdatedate"
      should_not have_text "Slug"
    end
    it "saves the preferences" do
      click_button "Save"
      should have_text "was successfully created"
    end
  end

  describe "view preferences" do
    before { click_link "View" }
    it "shows the organization's data" do
      should have_text "#{ois_client_preference.preference_name}"
      should have_text "Createddate"
      should have_text "Lastupdatedate"
      should_not have_text "Comments"
    end
  end

  describe "filter preferences" do
    context "a non-existent preference" do
      before do
        fill_in "Search Preference name", with: "no results"
        click_button "Filter"
      end
      it { should have_text "No Preferences found" }
    end
    context "an existing preference" do
      before do
        fill_in "Search Preference name", with: "#{CUT_TERM.match(ois_client_preference.preference_name)[0].gsub(/[\s-]/, "")}"
        click_button "Filter"
      end
      it { should have_text "#{ois_client_preference.preference_name}" }
    end
  end
end
