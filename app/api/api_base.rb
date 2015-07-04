class APIBase < Grape::API

  prefix 'api'
  format :json
  mount V1::BaseAPI
  # This could be uncommented to support an additional version
  # mount V2::Base

  add_swagger_documentation \
    api_version: 'v1',
    base_path: '/api'

end
