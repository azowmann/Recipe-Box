FactoryBot.define do
  factory :meal_plan do
    association :user
    week_start_date { Date.current.beginning_of_week(:monday) }
  end
end
