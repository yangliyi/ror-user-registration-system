class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Hi #{@user.name}, you've become our member!"
    )
  end
end
