ActiveAdmin.register Organization do
  filter :organization_name

  form do |f|
    f.inputs "Organization Info" do
      f.input :organization_name
      f.input :organization_npi
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state_code
      f.input :postal_code
      f.input :country_code, :as => :country
      f.input :disabled
    end

    f.inputs "Contact Info" do
      f.input :contact_first_name, :label => "First Name"
      f.input :contact_last_name, :label => "Last Name"
      f.input :contact_phone, :label => "Phone"
      f.input :contact_fax, :label => "Fax"
      f.input :contact_email, :label => "Email"
    end

    f.actions do
      f.action :submit, :label => "Save"
    end
  end

  index do
    column "Organization NPI", :organization_npi
    column :organization_name
    column :contact_first_name
    column :contact_last_name
    default_actions
  end

  show :title => :organization_name
end
