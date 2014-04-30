class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_cao!
  before_filter :set_cache_buster
  before_filter :check_update_password!


  # Redirect User According to Role.
  def after_sign_in_path_for(resource)
    if resource.is_admin?
      # root_path
      admin_organizations_path
    else
      application_admin_providers_path
    end
  end

  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    # Set to expire far in the past.
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    #response.headers["Expires"] = Time.now.httpdate
  end

  def check_update_password!
    if cao_signed_in?
      if current_cao.is_admin?
        redirect_to admin_organizations_path
      else
        redirect_to application_admin_providers_path if current_cao.old_passwords.count == 0
      end
    end    
  end
  
end
