module ActiveAdmin::IdentityServicesHelper
  def admin_identity_service_path_for_form(identity_service)
    if identity_service.new_record?
      admin_identity_services_path
    else
      admin_identity_service_path(identity_service)
    end
  end
end
