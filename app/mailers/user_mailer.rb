class UserMailer < ActionMailer::Base
  # default from: "sharonevas@gmail.com"
  default from: "notification@example.com"

  def send_resque_error(superadmin)
  	begin
  	  @recipient = superadmin.email
	  mail(to: @recipient, subject: "Redis queue exception")
  	rescue => e
  	  puts e.inspect
  	end
  end
end