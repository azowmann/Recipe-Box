FactoryBot.define do
  factory :meal_plan_entry do
    association :meal_plan
    association :recipe
    day_of_week { rand(0..6) }
    meal_type { MealPlanEntry::MEAL_TYPES.sample }
  end
end
