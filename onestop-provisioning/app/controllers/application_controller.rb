class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_cao!
  before_filter :set_cache_buster


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
    p "1dasdads"
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    # Set to expire far in the past.
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    #response.headers["Expires"] = Time.now.httpdate
  end
  
end
