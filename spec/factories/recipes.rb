FactoryBot.define do
  factory :recipe do
    association :user
    title { Faker::Food.dish }
    description { Faker::Lorem.sentence }
    instructions { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
    prep_time { rand(5..60) }
    cook_time { rand(10..120) }
    servings { rand(1..8) }
    public { false }

    trait :public do
      public { true }
    end
  end
end
