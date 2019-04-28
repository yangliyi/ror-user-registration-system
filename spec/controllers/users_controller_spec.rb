require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST create' do
    context 'does not create user if email is already used' do
      Given!(:user) { create(:user) }
      Given(:params) do
        {
          user: {
            email: user.email,
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end
      Then do
        expect { post :create, params: params }.not_to change(User, :count)
      end
    end

    context 'does not create user if passwords are not matched' do
      Given(:params) do
        {
          user: {
            email: 'new_email',
            password: 'password',
            password_confirmation: 'wrong_password'
          }
        }
      end
      Then do
        expect { post :create, params: params }.not_to change(User, :count)
      end
    end

    context 'does not create user if password is invalid' do
      Given(:params) do
        {
          user: {
            email: 'new_email',
            password: 'short',
            password_confirmation: 'short'
          }
        }
      end
      Then do
        expect { post :create, params: params }.not_to change(User, :count)
      end
    end

    context 'creates a user if email and password are valid' do
      Given(:params) do
        {
          user: {
            email: 'new_email',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end
      Then do
        expect { post :create, params: params }.to change(User, :count).by(1)
      end
    end
  end

  describe 'PATCH update' do
    Given!(:user) { create(:user) }
    Given(:session_params) { { user_id: user.id } }
    context 'does not update user email' do
      Given(:params) do
        {
          id: user.id,
          user: {
            name: user.name,
            email: 'new_email',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end
      When do
        patch :update, params: params, session: session_params
      end
      Then do
        expect { User.find(user.id).email == user.email }
      end
    end

    context 'does not update user password if not matched' do
      Given(:user_password) { user.encrypted_password }
      Given(:params) do
        {
          id: user.id,
          user: {
            name: user.name,
            password: 'password',
            password_confirmation: 'wrong_password'
          }
        }
      end
      When do
        patch :update, params: params, session: session_params
      end
      Then do
        expect { User.find(user.id).encrypted_password == user_password }
      end
    end

    context 'does not update user password if not valid' do
      Given(:user_password) { user.encrypted_password }
      Given(:params) do
        {
          id: user.id,
          user: {
            name: user.name,
            password: 'short',
            password_confirmation: 'short'
          }
        }
      end
      When do
        patch :update, params: params, session: session_params
      end
      Then do
        expect { User.find(user.id).encrypted_password == user_password }
      end
    end

    context 'updates a user successfully with valid params' do
      Given(:new_password) { 'newpassword' }
      Given(:new_name) { 'yangliyi' }
      Given(:params) do
        {
          id: user.id,
          user: {
            name: new_name,
            password: new_password,
            password_confirmation: new_password
          }
        }
      end
      When do
        patch :update, params: params, session: session_params
      end
      When(:updated_user) { User.find(user.id) }
      Then { BCrypt::Password.new(updated_user.encrypted_password) == new_password }
      And { updated_user.name == new_name }
    end
  end

  describe 'POST send_reset_email' do
    Given!(:user) { create(:user) }
    Given(:mailer_double) { double(deliver_later!: true) }
    Given do
      allow(UserMailer).to receive(:reset_password_email).and_return(mailer_double)
    end
    context 'does not send reset email if email is not valid' do
      Given(:params) do
        { email: 'invalid_email' }
      end
      When do
        post :send_reset_email, params: params
      end
      Then do
        expect(UserMailer).not_to have_received(:reset_password_email)
      end
    end

    context 'sends reset email if email exists' do
      Given(:params) do
        { email: user.email }
      end
      When do
        post :send_reset_email, params: params
      end
      Then do
        expect(UserMailer).to have_received(:reset_password_email).with(an_instance_of(User)).once
      end
    end
  end

  describe 'POST update_password' do
    Given!(:user) do
      create(
        :user,
        reset_password_token: SecureRandom.uuid,
        reset_password_sent_at: Time.now
      )
    end
    Given(:token) { user.reset_password_token }
    Given(:new_password) { 'newpassword' }
    Given(:params) do
      {
        token: token,
        user: {
          password: new_password,
          password_confirmation: new_password
        }
      }
    end
    Given(:encrypted_password) { user.encrypted_password }
    context 'does not reset password if token is expired' do
      Given { user.update(reset_password_sent_at: Time.now - 7.hours) }
      When do
        post :update_password, params: params
      end
      Then do
        User.find(user.id).encrypted_password == encrypted_password
      end
    end

    context 'resets password if token and password are valid' do
      When do
        post :update_password, params: params
      end
      Then do
        BCrypt::Password.new(User.find(user.id).encrypted_password) == new_password
      end
    end
  end
end