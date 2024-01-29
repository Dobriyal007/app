# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # rescue_from StandardError, with: :render_error

  private
  
  def render_error(exception)
    if exception.is_a?(ActionController::RoutingError)
      render plain: '404 Not Found', status: :not_found
    else
      @error_message = "Something went wrong. Please try again."
      render 'shared/error', formats: [:xlsx], status: :internal_server_error
    end
  end
end
