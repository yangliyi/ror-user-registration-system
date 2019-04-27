class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[show update]
  before_action :set_user, only: %i[show update]

  def new
    return redirect_to profile_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(email: user_params[:email], encrypted_password: encrypted_password)
    validate_password

    return render :new if @user.errors.any? || !@user.save

    UserMailer.welcome_email(@user).deliver_later!
    sign_in(@user)

    flash[:notice] = 'Successfully signed up!'
    redirect_to profile_path
  end

  def show; end

  def update
    validate_password

    return render :show if @user.errors.any? || !@user.update(name: user_params[:name], encrypted_password: encrypted_password)

    flash[:notice] = 'Successfully updated your profile info!'
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def validate_password
    if invalid_length?
      @user.errors.add(:invalid_length, "password must not be less than #{min_password_length} characters")
    end

    if password_not_confirmed?
      @user.errors.add(:password_not_matched, 'please confirm your password again')
    end
  end

  def invalid_length?
    password.size < min_password_length
  end

  def password
    user_params[:password]
  end

  def password_confirmation
    user_params[:password_confirmation]
  end

  def min_password_length
    @min_password_length ||= User.min_password_length
  end

  def password_not_confirmed?
    password != password_confirmation
  end

  def encrypted_password
    BCrypt::Password.create(password).to_s
  end

  def set_user
    @user = current_user
  end
end
