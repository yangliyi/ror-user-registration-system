class SessionsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  def new; end

  def create
    if user && correct_password?
      sign_in(user)
      flash[:notice] = 'Successfully logged in!'
      redirect_to profile_path
    else
      flash[:alert] = 'email or password is not correct'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Successfully logged out!'
    redirect_to login_path
  end

  private

  def user
    @user ||= User.find_by(email: params[:email])
  end

  def correct_password?
    BCrypt::Password.new(user.encrypted_password) == params[:password]
  end
end
