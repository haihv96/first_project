class SessionsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :logged_out_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t ".success", name: user.name
      redirect_to user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".success"
    redirect_to login_path
  end
end
