module PrecursorHelper
  def common_elements(ois_1_activity_url, ois_2_activity_url, enrollment=true)
    @user                               = FactoryGirl.create(:user)
    @ois_1                              = FactoryGirl.create(:ois)
    @ois_2                              = FactoryGirl.create(:ois)
    @ois_client                         = FactoryGirl.create(:ois_client)

    if(enrollment)
      @ois_1.enrollment_url             = ois_1_activity_url
      @ois_2.enrollment_url             = ois_2_activity_url
    else
      @ois_1.authentication_url         = ois_1_activity_url
      @ois_2.authentication_url         = ois_2_activity_url
    end

    @ois_client.client_name             = "carlos.casteneda"
    @ois_client.client_password         = "12345678911234567892123456789312345678941234567895"

    @ois_1.ois_name                     = "RamboMD"
    @ois_1.idp_level                    = 1

    @ois_2.ois_name                     = "FacebookMD"
    @ois_2.idp_level                    = 2

    @user.npi                           = "1234567890"
    @user.first_name                    = "Carlos"
    @user.last_name                     = "Casteneda"

    @user.oises << @ois_1
    @user.oises << @ois_2

    @user.save
    @ois_1.save
    @ois_2.save
    @ois_client.save
  end

  def request_idp_precursor
    common_elements("http://rambomd.com/register", "http://facebook.com/onestop/register")
  end

  def verify_identity_precursor
    common_elements("http://rambomd.com/login", "http://facebook.com/onestop/login", false)
  end
end
