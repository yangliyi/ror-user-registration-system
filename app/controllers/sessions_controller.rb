class SessionsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  def new; end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Successfully logged out!'
    redirect_to login_path
  end
end
