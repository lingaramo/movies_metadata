# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    name { Faker::Lorem.sentence }
    synopsis { Faker::Lorem.paragraph }
    preview_video_url { Faker::Internet.url }
    minutes { 90 + rand(90) }
  end
end
