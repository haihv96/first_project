class UserMailer < ApplicationMailer
  def change_password user
    @user = user
    mail to: @user.email, subject: t(".content")
  end

  def account_activation user
    @user = user
    mail to: @user.email, subject: t(".content")
  end

  def password_reset user
    @user = user
    mail to: @user.email, subject: t(".content")
  end
end
