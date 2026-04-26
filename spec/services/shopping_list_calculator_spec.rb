require 'rails_helper'

RSpec.describe ShoppingListCalculator do
  let(:user)      { create(:user) }
  let(:meal_plan) { create(:meal_plan, user: user) }

  let(:flour)   { create(:ingredient, name: "flour") }
  let(:eggs)    { create(:ingredient, name: "eggs") }
  let(:butter)  { create(:ingredient, name: "butter") }
  let(:garlic)  { create(:ingredient, name: "garlic") }

  def add_recipe_to_plan(day:, meal_type:, ingredients:)
    recipe = create(:recipe, user: user)
    ingredients.each do |ingredient, qty, unit|
      create(:recipe_ingredient, recipe: recipe, ingredient: ingredient, quantity: qty, unit: unit)
    end
    create(:meal_plan_entry, meal_plan: meal_plan, recipe: recipe, day_of_week: day, meal_type: meal_type)
    recipe
  end

  subject { described_class.new(meal_plan: meal_plan, user: user).call }

  describe '#call' do
    context 'when the meal plan is empty' do
      it 'returns an empty list' do
        expect(subject).to be_empty
      end
    end

    context 'when the meal plan has one recipe' do
      before do
        add_recipe_to_plan(
          day: 0, meal_type: "dinner",
          ingredients: [[flour, 2, "cup"], [eggs, 3, "whole"]]
        )
      end

      it 'returns all required ingredients' do
        names = subject.map { |item| item[:ingredient].name }
        expect(names).to include("flour", "eggs")
      end

      it 'returns the correct quantities' do
        flour_item = subject.find { |i| i[:ingredient].name == "flour" }
        expect(flour_item[:quantity]).to eq(2.0)
        expect(flour_item[:unit]).to eq("cup")
      end
    end

    context 'when two recipes require the same ingredient and unit' do
      before do
        add_recipe_to_plan(
          day: 0, meal_type: "breakfast",
          ingredients: [[flour, 1, "cup"]]
        )
        add_recipe_to_plan(
          day: 1, meal_type: "dinner",
          ingredients: [[flour, 2, "cup"]]
        )
      end

      it 'aggregates quantities for the same ingredient and unit' do
        flour_item = subject.find { |i| i[:ingredient].name == "flour" }
        expect(flour_item[:quantity]).to eq(3.0)
      end

      it 'returns only one row for that ingredient and unit' do
        flour_rows = subject.select { |i| i[:ingredient].name == "flour" }
        expect(flour_rows.size).to eq(1)
      end
    end

    context 'when the same ingredient appears with different units across recipes' do
      before do
        add_recipe_to_plan(
          day: 0, meal_type: "breakfast",
          ingredients: [[flour, 2, "cup"]]
        )
        add_recipe_to_plan(
          day: 1, meal_type: "dinner",
          ingredients: [[flour, 3, "tbsp"]]
        )
      end

      it 'keeps separate rows for different units of the same ingredient' do
        flour_rows = subject.select { |i| i[:ingredient].name == "flour" }
        expect(flour_rows.size).to eq(2)
      end
    end

    context 'when the user owns some ingredients' do
      before do
        create(:pantry_item, user: user, ingredient: flour)
        add_recipe_to_plan(
          day: 0, meal_type: "dinner",
          ingredients: [[flour, 2, "cup"], [eggs, 3, "whole"]]
        )
      end

      it 'excludes owned ingredients from the shopping list' do
        names = subject.map { |i| i[:ingredient].name }
        expect(names).not_to include("flour")
      end

      it 'keeps ingredients not in the pantry' do
        names = subject.map { |i| i[:ingredient].name }
        expect(names).to include("eggs")
      end
    end

    context 'when the user owns all required ingredients' do
      before do
        create(:pantry_item, user: user, ingredient: flour)
        create(:pantry_item, user: user, ingredient: eggs)
        add_recipe_to_plan(
          day: 0, meal_type: "dinner",
          ingredients: [[flour, 2, "cup"], [eggs, 3, "whole"]]
        )
      end

      it 'returns an empty list' do
        expect(subject).to be_empty
      end
    end

    context 'sorting' do
      before do
        add_recipe_to_plan(
          day: 0, meal_type: "dinner",
          ingredients: [[garlic, 3, "clove"], [butter, 2, "tbsp"], [eggs, 2, "whole"]]
        )
      end

      it 'sorts results alphabetically by ingredient name' do
        names = subject.map { |i| i[:ingredient].name }
        expect(names).to eq(names.sort)
      end
    end
  end
end
