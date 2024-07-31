module Api
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_json_request

    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

    def handle_record_not_found(exception)
      render(
        json: { errors: t("api.record_not_found", model: exception.model.titleize) },
        status: :not_found
      )
    end

    def render_errors(errors, status)
      render json: { errors: errors }, status: status
    end

    def ensure_json_request
      return if request.format == :json
      raise ActionController::RoutingError, 'Not supported format'
    end
  end
end
