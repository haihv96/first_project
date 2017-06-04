class SessionsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :logged_out_user, except: :destroy

  def new
  end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated
        log_in @user
        if params[:session][:remember_me] == Settings.remember_me
          remember @user
        else
          forget @user
        end
        redirect_to profile_path
      else
        flash[:danger] = t "login.require_activation"
        redirect_to login_path
      end
    else
      flash[:danger] = t "login.error"
      redirect_to login_path
    end
  end

  def destroy
    forget current_user
    log_out
    flash[:success] = t "logout.success"
    redirect_to login_path
  end
end
