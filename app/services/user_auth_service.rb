class UserAuthService
  attr_reader :user_params

  def initialize(user, user_params)
    @user_params = user_params
    @user = user
  end

  def validate_user
    validate_password
    validate_email
    @user
  end

  def encrypted_password(password)
    BCrypt::Password.create(password).to_s
  end

  private

  def validate_password
    if invalid_length?
      @user.errors.add(:base, "password must not be less than #{min_password_length} characters")
    end

    return unless password_not_matched?
    @user.errors.add(:base, 'please confirm your password again')
  end

  def invalid_length?
    return true unless password
    password.size < min_password_length
  end

  def password
    user_params[:password]
  end

  def min_password_length
    @min_password_length ||= User.min_password_length
  end

  def password_not_matched?
    return true unless password && password_confirmation
    password != password_confirmation
  end

  def password_confirmation
    user_params[:password_confirmation]
  end

  def validate_email
    return unless email_already_used?
    @user.errors.add(:base, 'email has already been taken')
  end

  def email_already_used?
    return true if @user.new_record? && User.exists?(email: @user.email)
    User.where.not(id: @user.id).where(email: @user.email).count > 0
  end
end