class UserMailer < ActionMailer::Base
  # default from: "sharonevas@gmail.com"
  default from: "Dr.First <notification@example.com>"

  def account_activate(user)
    @recipient  = user.email
    @user       = "#{user.first_name} #{user.last_name}"
    @url        = "http://10.100.10.203"
    mail(to: @recipient, subject: "Your account is activated.")
  end

  def account_deactivate(user)
    @recipient  = user.email
    @user       = "#{user.first_name} #{user.last_name}"
    @url        = "http://10.100.10.203"
    mail(to: @recipient, subject: "Your account is deactivated.")
  end

  def update_account(user)
    @recipient  = user.email
    @user       = "#{user.first_name} #{user.last_name}"
    @url        = "http://10.100.10.203"
    mail(to: @recipient, subject: "Account updated successfully.")
  end


  def update_password(user)
    @recipient  = user.email
    @user       = "#{user.first_name} #{user.last_name}"
    @url        = "http://10.100.10.203"
    mail(to: @recipient, subject: "Password updated successfully.")
  end

  def welcome_message(user)
    @recipient  = user.email
    @user       = "#{user.first_name} #{user.last_name}"
    @url        = "http://10.100.10.203"
    mail(to: @recipient, subject: "Welcome to Dr.First Provisioning system")
  end

  def send_resque_error(superadmin)
  	begin
  	  @recipient = superadmin.email
	  mail(to: @recipient, subject: "Redis queue exception")
  	rescue => e
  	  puts e.inspect
  	end
  end
  
end