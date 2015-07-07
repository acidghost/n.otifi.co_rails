module V1
  class BaseAPI < Grape::API

    mount V1::Users
    mount V1::Artists

  end
end
