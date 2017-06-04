class AccountActivationsController < ApplicationController
  before_action :set_user, only: :avail_token
  before_action :avail_token, only: :edit
  def notice_after_signup
  end

  def edit
    user.activate
    flash[:success] = t "login.activated", email: user.email
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by email: params[:email]
  end

  def avail_token
    unless (@user &&
        !@user.activated? &&
        @user.authenticated?(:activation, params[:id]))
      render_404
    end
  end
end
