class MealPlanEntry < ApplicationRecord
  MEAL_TYPES = %w[breakfast lunch dinner].freeze

  belongs_to :meal_plan
  belongs_to :recipe

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :meal_type, presence: true, inclusion: { in: MEAL_TYPES }
  validates :meal_type, uniqueness: { scope: [:meal_plan_id, :day_of_week] }
end
