class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation user
    @user = user
    @message = t "mailer.activation"
    mail to: user.email, subject: @message
  end

  def password_reset user
    @user = user
    @message = t "mailer.password_reset"
    mail to: user.email, subject: @message
  end
end
