class UsersController < ApplicationController
  before_action :load_user, only: :show

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end
