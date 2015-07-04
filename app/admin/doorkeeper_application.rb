ActiveAdmin.register Doorkeeper::Application do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :name, :redirect_uri

  # ActiveAdmin will name Rails Engine models with their namespaced names (ex:doorkeeper_application) which
  # will fail validation and spit back a form with errors where the fields would otherwise be valid.
  # Setting the model resource name back to 'application'.
  controller do
    resources_configuration[:self][:instance_name] = 'application'
  end

  index do
    selectable_column
    id_column
    column :name
    column :uid
    column :secret
    column :redirect_uri
    column :scopes
    column :created_at
    actions
  end

  filter :name
  filter :uid
  filter :secret
  filter :redirect_uri
  filter :scopes
  filter :created_at

  form do |f|
    f.inputs 'API Application Details' do
      f.input :name
      f.input :redirect_uri
      f.input :scopes
    end
    f.actions
  end

end
