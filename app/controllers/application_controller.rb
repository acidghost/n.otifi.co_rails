class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    render json: { message: 'API starts from /api endpoint.', follow: "#{request.base_url}/api/v1" }
  end
end
