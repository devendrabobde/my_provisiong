module DomHelpers
  def selector_for(scope)
    case scope
    when "the admin menu bar"
      "#header"
    end
  end
end

World(DomHelpers)
