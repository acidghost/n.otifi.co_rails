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

        def current_user
          resource_owner
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
      # before do
      #   error!('Unauthorized', 401) unless headers['Authorization'] == 'some token'
      # end

      rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |_e|
        error = { id: 'unauthorized',
                  message: 'You must provide an OAuth token to complete this request.' }

        error_response(status: 401, message: error)
      end

      rescue_from WineBouncer::Errors::OAuthForbiddenError do |_e|
        error = { id: 'forbidden',
                  message: 'This operation is not permitted with this scope.' }

        error_response(status: 403, message: error)
      end
    end

  end
end
