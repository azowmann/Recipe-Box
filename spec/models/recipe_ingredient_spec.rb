require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:recipe) }
    it { is_expected.to belong_to(:ingredient) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:unit) }

    it 'is invalid when quantity is zero' do
      expect(build(:recipe_ingredient, quantity: 0)).not_to be_valid
    end

    it 'is invalid when quantity is negative' do
      expect(build(:recipe_ingredient, quantity: -1)).not_to be_valid
    end

    it 'is valid when quantity is positive' do
      expect(build(:recipe_ingredient, quantity: 1.5)).to be_valid
    end

    it 'is invalid when the same ingredient appears twice on the same recipe' do
      recipe = create(:recipe)
      ingredient = create(:ingredient)
      create(:recipe_ingredient, recipe: recipe, ingredient: ingredient)
      duplicate = build(:recipe_ingredient, recipe: recipe, ingredient: ingredient)
      expect(duplicate).not_to be_valid
    end

    it 'is valid when the same ingredient appears on different recipes' do
      ingredient = create(:ingredient)
      recipe_a = create(:recipe)
      recipe_b = create(:recipe)
      create(:recipe_ingredient, recipe: recipe_a, ingredient: ingredient)
      expect(build(:recipe_ingredient, recipe: recipe_b, ingredient: ingredient)).to be_valid
    end
  end
end
