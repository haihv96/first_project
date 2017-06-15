class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by email: params[:password_reset][:email].downcase

    if user
      user.create_reset_digest
      user.send_password_reset_email
      flash[:info] = t ".success"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params) &&
      @user.password_present?(params[:user][:password])
      @user.update_column :reset_digest, nil
      flash[:success] = t ".success"
      redirect_to login_path
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    render_404 unless @user
  end

  def valid_user
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
      render_404
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".error"
      redirect_to new_password_reset_url
    end
  end
end
