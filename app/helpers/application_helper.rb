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

  ### Overriding rails NavbarHelper methods for adding custom css class
  
  def drop_down_link(name)
    link_to(name_and_caret(name), "#", :class => "dropdown-toggle username-dropdown", "data-toggle" => "dropdown")
  end

end