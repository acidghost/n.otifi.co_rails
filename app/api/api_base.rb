class APIBase < Grape::API

  prefix 'api'
  format :json

  use ::WineBouncer::OAuth2

  mount V1::BaseAPI

  add_swagger_documentation \
    api_version: 'v1',
    mount_path: '/swagger_doc'

end
