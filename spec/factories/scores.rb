# frozen_string_literal: true

FactoryBot.define do
  factory :score do
    score { rand(101) }
  end
end
