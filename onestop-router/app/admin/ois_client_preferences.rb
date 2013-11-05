ActiveAdmin.register OisClientPreference, :as => 'Preferences' do
  filter :preference_name

  form do |f|
    f.inputs "Preference Info" do
      f.input :preference_name
      f.input :faq_url
      f.input :help_url
      f.input :logo_url
    end

    f.actions do
      f.action :submit, :label => "Save"
    end
  end

  index do
    column :preference_name
    column :faq_url, :label => "FAQ URL"
    column :help_url
    column :logo_url
    default_actions
  end

  show :title => :preference_name
end
