class UsersController < ApplicationController
  before_action :init_user, only: [:new, :signup]
  before_action :logged_in_user, except: [:signup, :signup_create]
  before_action :logged_out_user, only: [:signup, :signup_create]
  before_action :set_user, only: [:show, :edit, :destroy]
  before_action :is_admin?, only: [:new, :create, :edit, :update, :destroy]
  before_action :init_current_user, only: [:profile]

  def index
    @users = User.page params[:page]
  end

  def new
  end

  def signup
  end

  def show
    if current_user? @user
      redirect_to profile_path
    else
      @microposts = @user.microposts.time_line.page params[:page]
      render :profile
    end
  end

  def profile
    @micropost = Micropost.new
    @microposts = @user.microposts.time_line.page params[:page]
  end

  def create
    @user = User.new admin_user_params
    if @user.save
      flash[:success] = t "manager.users.create_success"
      redirect_to users_path
    else
      render :new
    end
  end

  def signup_create
    @user = User.new basic_user_params
    if @user.save
      @user.send_account_activation_email
      flash[:success] = t "signup.success"
      redirect_to signup_verify_path
    else
      render :signup
    end
  end

  def edit
  end

  def destroy
    if @user && @user.destroy
      redirect_to users_path
    else
      render_404
    end
  end

  private

  def init_user
    @user = User.new
  end

  def set_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end

  def basic_user_params
    params.require(:user)
        .permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user_params
    params.require(:user).
        permit(:name, :email, :password, :password_confirmation, :role)
  end
end
