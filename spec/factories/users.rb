FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    encrypted_password { BCrypt::Password.create(Forgery(:basic).password).to_s }
    name { Forgery(:name).full_name }
  end
end