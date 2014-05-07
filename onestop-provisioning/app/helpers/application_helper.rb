module ApplicationHelper
  def resource_name
    :cao
  end

  def resource
    @resource ||= Cao.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:cao]
  end
end
