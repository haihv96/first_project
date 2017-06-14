class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "login.require"
      redirect_to login_path
    end
  end

  def is_admin?
    render_404 unless current_user.admin?
  end

  def logged_out_user
    redirect_to root_path if logged_in?
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", layout: false, status: 500
  end

  def render_422
    render file: "#{Rails.root}/public/422.html", layout: false, status: 422
  end
end
