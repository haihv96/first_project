class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "login.require_login"
      redirect_to login_path
    end
  end

  def logged_out_user
    redirect_to root_path if logged_in?
  end

  def is_admin?
    user = current_user
    unless user.admin?
      forget user
      log_out
      flash[:danger] = t "words.permission_denied"
      redirect_to login_path
    end
  end

  def init_current_user
    @user = current_user
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def render_422
    render file: "#{Rails.root}/public/422.html", status: 422, layout: false
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", status: 500, layout: false
  end
end
