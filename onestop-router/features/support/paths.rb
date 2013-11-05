module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the admin page/
      admin_root_path
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        page_name =~ /the (.*) page/
        "/#{$1.split(/\s+/).join('/')}"
      end
    end
  end
end

World(NavigationHelpers)
