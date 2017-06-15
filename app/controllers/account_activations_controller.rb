class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    
    if user && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = t ".success"
      redirect_to login_path
    else
      render_404
    end
  end
end
