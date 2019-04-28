require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  Given!(:user) { create(:user) }
  describe 'POST create' do
    context 'does not log in if password is not valid' do
      When do
        post :create,
             params: {
               email: user.email,
               password: 'invalidpassword'
             }
      end
      Then { request.session[:user_id].nil? }
    end

    context 'stays logged in if email and password are valid' do
      Given(:password) { 'password' }
      Given { user.update(encrypted_password: BCrypt::Password.create(password).to_s) }
      When do
        post :create,
             params: {
               email: user.email,
               password: password
             }
      end
      Then { request.session[:user_id] == user.id }
    end
  end

  describe 'DELETE destroy' do
    Given(:password) { 'password' }
    Given { user.update(encrypted_password: BCrypt::Password.create(password).to_s) }
    context 'logs out if already logged in' do
      Given do
        post :create,
             params: {
               email: user.email,
               password: password
             }
      end
      When do
        delete :destroy,
               params: {
                 email: user.email,
                 password: password
               }
      end
      Then { request.session[:user_id].nil? }
    end
  end
end
