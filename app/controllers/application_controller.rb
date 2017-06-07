class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", layout: false, status: 500
  end

  def render_422
    render file: "#{Rails.root}/public/404.html", layout: false, status: 422
  end
end
