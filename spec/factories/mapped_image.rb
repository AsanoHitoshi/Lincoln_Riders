# frozen_string_literal: true
require "refile/file_double"

FactoryBot.define do
  factory :mapped_image do
    sequence(:text) { |n| "text#{n}" }
    sequence(:position_lat) { 0 }
    sequence(:position_lng) { 0 }

    mapped_image = MappedImage.new
    mapped_image.image = Refile::FileDouble.new("dummy", "file.txt", content_type: "text/plain")
    sequence(:image_id) { |n| mapped_image.image.id }

    trait :no_tex do
      text {}
    end

    trait :too_long_tex do
      text {Faker::Lorem.characters(820)}
    end
  end
end
