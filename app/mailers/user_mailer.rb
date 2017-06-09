class UserMailer < ApplicationMailer
  def change_password user
    @user = user
    mail to: @user.email, subject: "Your password has been change"
  end
end
