Feature: COA forgot password
  In order to retrieve lost password
  As a COA of this site
  I want to reset it
  
@selenium
@no-database-cleaner
Scenario: COA forgot password
  Given I go to application home page
  And I should be able to see forgot password link
  And I should be able to click on forgot password link
  When I enter email on the reset password form
  And I press Send me reset password instructions button
  Then I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.
  And I should receive email with forget password instructions
  When I open email then I should be able to see Change my password link
  And I follow Change my password link in the email
  Then I should be able to enter new password and confirmation password
  When I click on Change my password
  Then I should be able to see Your password was changed successfully. You are now signed in

@selenium
@no-database-cleaner
Scenario: COA forgot password reset link in the email must expire if COA has already updated the password using the same link
  Given I go to application home page
  And I should be able to see forgot password link
  And I should be able to click on forgot password link
  When I enter email on the reset password form
  And I press Send me reset password instructions button
  Then I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.
  And I should receive email with forget password instructions
  When I open an email then I should be able to see Change my password link
  And I follow Change my password link in the email
  Then I should be able to see message as Reset password token has expired. please request a new one

@selenium
@no-database-cleaner
Scenario: COA forgot password reset link in the email must expire if COA did not update the password using link within valid period of time
  Given I go to application home page
  And I should be able to see forgot password link
  And I should be able to click on forgot password link
  When I enter email on the reset password form
  And I press Send me reset password instructions button
  Then I sould be able to see You will receive an email with instructions about how to reset your password in a few minutes.
  And I should receive email with forget password instructions
  When I open my email then I should be able to see Change my password link
  And I follow Change my password link in the email
  Then I should be able to see message as Reset password token has expired. please request a new one
