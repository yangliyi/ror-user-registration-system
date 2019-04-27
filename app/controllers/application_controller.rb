class ApplicationController < ActionController::Base

  private

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= begin
      user_id = session[:user_id]
      return unless user_id
      User.find(user_id)
    end
  end

  def authenticate_user!
    return if current_user
    redirect_to root_path
  end
end
