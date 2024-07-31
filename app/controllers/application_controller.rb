class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_not_found

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end
end
