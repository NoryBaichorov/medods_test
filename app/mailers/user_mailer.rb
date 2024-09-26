class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def warn_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your IP address has been changed')
  end
end
