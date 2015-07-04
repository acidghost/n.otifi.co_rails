module V1
  class BaseAPI < Grape::API

    mount V1::Users

  end
end
