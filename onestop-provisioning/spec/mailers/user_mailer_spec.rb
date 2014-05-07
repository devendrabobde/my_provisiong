require "spec_helper"

describe UserMailer do
  describe "#update_account" do
  	it "should send an email after updating information for a user" do
  	  user = FactoryGirl.create(:cao, email: Faker::Internet.email, username: Faker::Internet.user_name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  	  email = UserMailer.update_account(user)
	  email.subject.should == "Account updated successfully."
  	end
  end
  describe "#update_password" do
  	it "should send an email after updating password for a user" do
  	  user = FactoryGirl.create(:cao, email: Faker::Internet.email, username: Faker::Internet.user_name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  	  email = UserMailer.update_password(user)
  	  email.subject.should == "Password updated successfully."
  	end
  end
  describe "#send_resque_error" do
  	it "should send an email if any error encounters in resque job" do
  	  superadmin = FactoryGirl.create(:cao, email: Faker::Internet.email, username: Faker::Internet.user_name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  	  email = UserMailer.send_resque_error(superadmin)
  	  email.subject.should == "Redis queue exception"
  	end
  end
end
