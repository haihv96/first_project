class MicropostsController < ApplicationController
  before_action :init_current_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t "microposts.create_success"
      redirect_to profile_path
    else
      @microposts = @user.microposts.time_line.page params[:page]
      render "users/profile"
    end
  end

  def destroy
    micropost = Micropost.find_by id: params[:id]
    if micropost && (micropost.in_user?(current_user) || current_user.admin?)
      micropost.delete
      flash[:success] = t "microposts.delete_success"
      redirect_to user_path micropost.user_id
    else
      render_404
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:context, :picture)
  end
end
