class PasswordResetsController < ApplicationController
  before_action :init, only: [:edit, :update]
  before_action :validate_user, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:danger] = t "password_resets.sent_mail"
      render :sent_mail
    else
      flash[:danger] = t "password_resets.email_not_found"
      redirect_to new_password_reset_path
    end

  end

  def update
    if @user.update_attributes password_params
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "password_resets.success"
      redirect_to login_path
    else
      render :edit
    end
  end

  private

  def init
    @user = User.find_by email: params[:email]
    @user.reset_token = params[:id]
  end

  def validate_user
    unless @user &&
        @user.activated? &&
        !@user.password_reset_expired? &&
        @user.authenticated?(:reset, params[:id])
      render_404
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
