class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Hi #{@user.name}, you've become our member!"
    )
  end

  def reset_password_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: 'Please click the link in the email to reset your password'
    )
  end
end
