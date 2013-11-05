ActiveAdmin.register OisClient, :as => "Application" do

  filter :client_name

  form :partial => 'form'

  show :title => :client_name

  index do
    column :client_name
    column :ip_address_concat

    default_actions
  end
end
