require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:recipe_ingredients).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:recipe_ingredients) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it 'is invalid when name is a duplicate (case-insensitive)' do
      create(:ingredient, name: "garlic")
      duplicate = build(:ingredient, name: "Garlic")
      expect(duplicate).not_to be_valid
    end

    it 'is valid with a unique name' do
      expect(build(:ingredient, name: "saffron")).to be_valid
    end
  end

  describe 'name normalization' do
    it 'strips whitespace and downcases before save' do
      ingredient = create(:ingredient, name: "  Olive Oil  ")
      expect(ingredient.reload.name).to eq("olive oil")
    end

    it 'downcases mixed-case names' do
      ingredient = create(:ingredient, name: "Sea Salt")
      expect(ingredient.reload.name).to eq("sea salt")
    end
  end
end
