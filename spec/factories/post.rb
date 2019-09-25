# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:text) { |n| "text#{n}" }


    trait :no_tex do
      text {}
    end

    trait :too_long_tex do
      text {Faker::Lorem.characters(820)}
    end
  end
end
