FactoryBot.define do
  factory :recipe_ingredient do
    association :recipe
    association :ingredient
    quantity { rand(0.25..4.0).round(2) }
    unit { %w[cup tbsp tsp g kg ml oz lb].sample }
  end
end
