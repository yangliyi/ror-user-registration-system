require 'rails_helper'

RSpec.describe UserAuthService do
  describe '#validate_user' do
    Given(:service) do
      UserAuthService.new(User.new, user_params)
    end
    context 'returns error if password is short' do
      Given(:user_params) do
        {
          password: 'short',
          password_confirmation: 'short'
        }
      end
      When(:user) { service.validate_user }
      Then { user.errors.size == 1 }
      And do
        user.errors.full_messages[0] == 'Invalid length password must not be less than 8 characters'
      end
    end

    context 'returns error if passwords are not matched' do
      Given(:user_params) do
        {
          password: 'password',
          password_confirmation: 'wrong_confirmation'
        }
      end
      When(:user) { service.validate_user }
      Then { user.errors.size == 1 }
      And do
        user.errors.full_messages[0] == 'Password not matched please confirm your password again'
      end
    end

    context 'returns no error if password is valid' do
      Given(:user_params) do
        {
          password: 'password',
          password_confirmation: 'password'
        }
      end
      When(:user) { service.validate_user }
      Then { user.errors.size.zero? }
    end
  end
end
