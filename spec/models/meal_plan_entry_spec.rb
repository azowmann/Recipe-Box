require 'rails_helper'

RSpec.describe MealPlanEntry, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:meal_plan) }
    it { is_expected.to belong_to(:recipe) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:day_of_week) }
    it { is_expected.to validate_presence_of(:meal_type) }

    it 'is invalid when day_of_week is out of range' do
      expect(build(:meal_plan_entry, day_of_week: 7)).not_to be_valid
      expect(build(:meal_plan_entry, day_of_week: -1)).not_to be_valid
    end

    it 'is valid for all days 0 through 6' do
      (0..6).each do |day|
        expect(build(:meal_plan_entry, day_of_week: day)).to be_valid
      end
    end

    it 'is invalid with an unrecognised meal_type' do
      expect(build(:meal_plan_entry, meal_type: "brunch")).not_to be_valid
    end

    it 'is valid for each recognised meal_type' do
      MealPlanEntry::MEAL_TYPES.each do |type|
        expect(build(:meal_plan_entry, meal_type: type)).to be_valid
      end
    end

    it 'is invalid when the same slot is already taken on the same meal plan' do
      plan = create(:meal_plan)
      create(:meal_plan_entry, meal_plan: plan, day_of_week: 0, meal_type: "lunch")
      duplicate = build(:meal_plan_entry, meal_plan: plan, day_of_week: 0, meal_type: "lunch")
      expect(duplicate).not_to be_valid
    end

    it 'is valid for the same day and meal_type on a different meal plan' do
      create(:meal_plan_entry, day_of_week: 0, meal_type: "lunch")
      other_plan = create(:meal_plan, week_start_date: 1.week.from_now.to_date.beginning_of_week(:monday))
      expect(build(:meal_plan_entry, meal_plan: other_plan, day_of_week: 0, meal_type: "lunch")).to be_valid
    end
  end
end
