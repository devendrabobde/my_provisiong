ActiveAdmin.register Ois, :as => "Identity Service" do

  filter :ois_name

  form :partial => 'form'

  show :title => :ois_name

  index do
    column "Identity Service Name", :ois_name
    column :ip_address_concat

    default_actions
  end
end
