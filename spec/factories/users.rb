# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '123456' }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
