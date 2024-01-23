# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :render_error

  private

  def render_error(exception)
    @error_message = "Something went wrong. Please try again."
    render 'shared/error', status: :internal_server_error
  end
end
