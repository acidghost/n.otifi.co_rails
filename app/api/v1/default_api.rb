module V1
  module DefaultAPI

    extend ActiveSupport::Concern

    included do
      version 'v1', using: :path
      format :json
      default_format :json

      helpers do
        def permitted_params
          @permitted_params ||= declared(params, include_missing: false)
        end

        def logger
          Rails.logger
        end
      end

      # global handler for simple not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      # global exception handler, used for error notifications
      rescue_from :all do |e|
        if Rails.env.development?
          raise e
        else
          # Raven.capture_exception(e)
          error_response(message: 'Internal server error', status: 500)
        end
      end

      # HTTP header based authentication
      before do
        error!('Unauthorized', 401) unless headers['Authorization'] == 'some token'
      end
    end

  end
end
