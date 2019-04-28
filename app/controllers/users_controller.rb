class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show update]
  before_action :set_user, only: %i[show update]
  before_action :set_token, only: %i[reset_password update_password]
  before_action :validate_reset_token, only: %i[reset_password update_password]

  def new
    return redirect_to profile_path if current_user
    @user = User.new
  end

  def create
    @user = auth_service.validate_user

    return render :new if @user.errors.any? || !@user.update(email: user_params[:email], encrypted_password: encrypted_password)

    UserMailer.welcome_email(@user).deliver_later!
    sign_in(@user)

    flash[:notice] = 'Successfully signed up!'
    redirect_to profile_path
  end

  def show; end

  def update
    @user = auth_service.validate_user

    return render :show if @user.errors.any? || !@user.update(name: user_params[:name], encrypted_password: encrypted_password)

    flash[:notice] = 'Successfully updated your profile info!'
    redirect_to profile_path
  end

  def forgot_password; end

  def send_reset_email
    @user = User.find_by(email: params[:email])
    if @user&.generate_token
      UserMailer.reset_password_email(@user).deliver_later!

      flash[:notice] = 'Reset password email is sent'
      redirect_to login_path
    else
      flash[:alert] = 'email is not correct'
      redirect_to forgot_password_users_path
    end
  end

  def reset_password; end

  def update_password
    @user = auth_service.validate_user
    if @user.update(encrypted_password: encrypted_password, reset_password_token: nil, reset_password_sent_at: nil)
      flash[:notice] = 'password is updated successfully'
      redirect_to login_path
    else
      render :reset_password
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_token
    @token = params[:token]
  end

  def validate_reset_token
    @user = User.find_by(reset_password_token: @token)
    return if @user &.token_not_expired?
    flash[:alert] = 'link is expired'
    redirect_to root_path
  end

  def auth_service
    @auth_service ||= UserAuthService.new(@user || User.new, user_params)
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def encrypted_password
    auth_service.encrypted_password(user_params[:password])
  end
end
