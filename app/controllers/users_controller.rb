class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create,
    :edit_password, :update_password]
  before_action :logged_in_user, except: [:new, :create]
  before_action :can_create, only: [:new, :create]
  before_action :can_edit, only: [:edit, :update]
  before_action :can_delete, only: :destroy

  def index
    @users = User.order_id.page(params[:page]).per Settings.users.per_page
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
    @microposts = @user.microposts.order_date
      .page(params[:page]).per Settings.microposts.per_page
  end

  def edit_password
  end

  def update_password
    if current_user.update_attributes edit_password_params
      log_out
      flash[:success] = t ".success"
      redirect_to login_path
    else
      render :edit_password
    end
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:success] = t ".success"
      redirect_to login_path
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success", email: @user.email
      redirect_to users_path
    else
      render_404
    end
  end

  def following
    @title = t ".title"
    @users = @user.following.page(params[:page]).per Settings.follows.per_page
    render :show_follow
  end

  def followers
    @title = t ".title"
    @users = @user.followers.page(params[:page]).per Settings.follows.per_page
    render :show_follow
  end

  private

  def user_params
    params.require(:user)
      .permit :email, :name, :phone, :birthday, :gender, :role,
        :current_password, :password, :password_confirmation
  end

  def edit_password_params
    params.require(:user).permit :current_password, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end

  def can_edit
    is_admin? unless current_user? @user
  end

  def can_delete
    is_admin?
    render_404 if current_user? @user
  end

  def can_create
    logged_out_user unless logged_in? && current_user.is_admin?
  end
end
