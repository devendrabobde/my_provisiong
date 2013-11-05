require 'spec_helper'
require 'ruby-debug'

describe "AdminManagesApplications" do
  subject { page }
  let(:admin_user)            { FactoryGirl.create(:admin_user) }
  let(:ois_client)            { FactoryGirl.create(:ois_client) }
  let(:ois_client_preference) { FactoryGirl.create(:ois_client_preference) }

  before do
    visit new_admin_user_session_path
    admin_user_email_login(admin_user)
    ois_client.save
    click_link "Applications"
  end

  describe "list applications" do
    it "has exactly 2 columns" do
      should have_selector('table#applications.index th a', count: 2)
      should have_selector('table#applications.index th a', text: "Client Name")
      should have_selector('table#applications.index th a', text: "Ip Address Concat")
    end
  end

  describe "add new application" do
    before do
      ois_client_preference.preference_name = "OneStop Default"
      ois_client_preference.client_name     = "OneStop"
      ois_client_preference.save
      click_link "New Application"
    end

    context "new application page display" do
      it "does not show some data" do
        should_not have_text "Created date"
        should_not have_text "Last update date"
        should_not have_text "Slug"
        should_not have_text "Created date as number"
        should_not have_text "Last update date as number"
      end
    end

    context "fill info for new application" do
      before do
        fill_in "Client name",                              with: "BuildBetterSoftware.com"
        fill_in "Ip address concat",                        with: "10.1.1.1"
        select "#{ois_client_preference.preference_name}",  from: "Preferences"
        check("Disabled")
        click_button "Save"
      end
      it { should have_text "was successfully created" }
      it "has its latest OisClient last modified by the admin_user logged in above" do
        pending "tests pass intermittently"
        ois_client_audited = OisClient.last.audits
        ois_client_audited.last.user_id.should == admin_user.id
      end
    end
  end

  describe "view application" do
    before { click_link "View" }
    it "shows application data" do
      should have_text "#{ois_client.client_name}"
      should have_text "Createddate"
      should have_text "Lastupdatedate"
      should have_text "Disabled"
    end
    it{ should_not have_text "Comments" }
  end

  describe "generate new password" do
    before do
      click_link "Edit"
      @previous_password = find_field("Client password").value
    end
    it "generates a new password", js: true do
      click_button "Generate new password"
      click_link "Show Password"
      @new_password = find_field("Client password").value
      @new_password.should_not be_blank
      @new_password.size.should be_between(50, 80)
      @new_password.should be_a_kind_of String
      @previous_password.should_not == find_field("Client password").value
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
      should have_field "Client password", type: "password"
    end
    it "unmasks the password if 'Show Password' is clicked", js: true do
      click_link "Show Password"
      should have_field "Client password", type: "text"
    end
  end

  describe "filter applications" do
    it { should have_text "Search Client name" }
    context "a non-existent application" do
      before do
        fill_in "Search Client name", with: "no results"
        click_button "Filter"
      end
      it { should have_text "No Applications found" }
    end
    context "an existing application" do
      before do
        fill_in "Search Client name", with: "#{CUT_TERM.match(ois_client.client_name)[0].gsub(/[\s-]/, "")}"
        click_button "Filter"
      end
      it { should have_text "#{ois_client.client_name}" }
    end
  end

end
