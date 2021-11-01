class ApplicationController < ActionController::API
  def bad_request(errors)
    render json: { errors: errors }, status: :bad_request
  end
end
