module V1
  class Users < Grape::API

    include DefaultAPI

    resource :users do

      desc 'Return the list of users.'
      get do
        User.all
      end

      desc 'Create a new user.'
      params do
        optional :first_name, type: String
        optional :last_name, type: String
        requires :email, type: String
        requires :password, type: String
      end
      post do
        User.create! permitted_params
      end

    end

  end
end
