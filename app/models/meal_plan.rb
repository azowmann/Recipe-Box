class MealPlan < ApplicationRecord
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  belongs_to :user
  has_many :meal_plan_entries, dependent: :destroy
  has_many :recipes, through: :meal_plan_entries

  validates :week_start_date, presence: true
  validates :week_start_date, uniqueness: { scope: :user_id }
  validate :week_start_date_is_monday

  scope :current_week, -> { where(week_start_date: Date.current.beginning_of_week(:monday)) }

  private

  def week_start_date_is_monday
    return unless week_start_date
    errors.add(:week_start_date, "must be a Monday") unless week_start_date.monday?
  end
end
