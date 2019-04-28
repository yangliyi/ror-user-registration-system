RSpec.describe User, type: :model do
  describe 'email validation' do
    Given(:user) { build(:user, email: 'aaa@aaa_aaa') }
    When(:validation_result) { user.valid? }
    Then { validation_result == false }
    And { user.errors.size == 1 }
    And { user.errors.full_messages[0] == 'Email only allows valid emails' }
  end

  describe 'self.min_password_length' do
    context 'returns value based on the constant in user model' do
      Then { User.min_password_length == User::MIN_PASSWORD_LENGTH }
    end
  end

  describe '#token_not_expired?' do
    context 'returns false if value is not set' do
      Given(:user) { build(:user) }
      Then { user.token_not_expired? == false }
    end

    context 'returns false if reset_password_sent_at is over RESET_EXPIRED_HOURS' do
      Given(:user) do
        build(
          :user,
          reset_password_sent_at: Time.now - 7.hours,
          reset_password_token: SecureRandom.uuid
        )
      end
      Then { user.token_not_expired? == false }
    end

    context 'returns true if reset_password_sent_at is within RESET_EXPIRED_HOURS' do
      Given(:user) do
        build(
          :user,
          reset_password_sent_at: Time.now - 5.hours,
          reset_password_token: SecureRandom.uuid
        )
      end
      Then { user.token_not_expired? }
    end
  end

  describe '#generate_token' do
    context 'updates user with reset_password_token and reset_password_sent_at' do
      Given(:user) { create(:user) }
      When { user.generate_token }
      Then { user.reset_password_token.present? && user.reset_password_sent_at.present? }
    end
  end
end