require 'rails_helper'

RSpec.describe MealPlan, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:meal_plan_entries).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:meal_plan_entries) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:week_start_date) }

    it 'is invalid when two plans share the same user and week_start_date' do
      user = create(:user)
      create(:meal_plan, user: user, week_start_date: Date.current.beginning_of_week(:monday))
      duplicate = build(:meal_plan, user: user, week_start_date: Date.current.beginning_of_week(:monday))
      expect(duplicate).not_to be_valid
    end

    it 'is valid when the same week_start_date is used by different users' do
      create(:meal_plan, week_start_date: Date.current.beginning_of_week(:monday))
      other = build(:meal_plan, week_start_date: Date.current.beginning_of_week(:monday))
      expect(other).to be_valid
    end

    it 'is invalid when week_start_date is not a Monday' do
      plan = build(:meal_plan, week_start_date: Date.current.next_occurring(:tuesday))
      expect(plan).not_to be_valid
      expect(plan.errors[:week_start_date]).to include("must be a Monday")
    end

    it 'is valid when week_start_date is a Monday' do
      expect(build(:meal_plan, week_start_date: Date.current.beginning_of_week(:monday))).to be_valid
    end
  end

  describe '.current_week' do
    it 'returns the plan for the current week' do
      current = create(:meal_plan, week_start_date: Date.current.beginning_of_week(:monday))
      old     = create(:meal_plan, week_start_date: 1.week.ago.to_date.beginning_of_week(:monday))
      expect(MealPlan.current_week).to include(current)
      expect(MealPlan.current_week).not_to include(old)
    end
  end
end
