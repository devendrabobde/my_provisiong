class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_cao!

  # Redirect User According to Role.
  def after_sign_in_path_for(resource)
    if resource.is_admin?
      # root_path
      admin_organizations_path
    else
      application_admin_providers_path
    end
  end
end
