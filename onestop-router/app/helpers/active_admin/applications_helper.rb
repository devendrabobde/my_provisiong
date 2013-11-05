module ActiveAdmin::ApplicationsHelper
  def admin_application_path_for_form(application)
    if application.new_record?
      admin_applications_path
    else
      admin_application_path(application)
    end
  end
end
