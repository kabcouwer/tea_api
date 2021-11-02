class ApplicationController < ActionController::API
  def bad_request(errors)
    render json: { errors: errors }, status: :bad_request
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
