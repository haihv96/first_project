class SessionsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :logged_out_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user

        if params[:session][:remember_me] == Settings.user.remember_me
          remember user
        else
          forget user
        end
        flash[:success] = t ".success", name: user.name
        redirect_back_or user
      else
        flash[:warning] = t ".error.activated"
        redirect_to login_path
      end
    else
      flash.now[:danger] = t ".error.password"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".success"
    redirect_to login_path
  end
end

