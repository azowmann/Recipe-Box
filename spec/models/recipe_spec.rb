require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:recipe_ingredients).dependent(:destroy) }
    it { is_expected.to have_many(:ingredients).through(:recipe_ingredients) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:instructions) }

    it 'is invalid without public set' do
      recipe = build(:recipe, public: nil)
      expect(recipe).not_to be_valid
    end

    it 'is valid with public: false' do
      expect(build(:recipe, public: false)).to be_valid
    end

    it 'is valid with public: true' do
      expect(build(:recipe, public: true)).to be_valid
    end

    context 'when prep_time is present' do
      it 'is invalid when prep_time is zero' do
        expect(build(:recipe, prep_time: 0)).not_to be_valid
      end

      it 'is invalid when prep_time is negative' do
        expect(build(:recipe, prep_time: -5)).not_to be_valid
      end

      it 'is valid when prep_time is positive' do
        expect(build(:recipe, prep_time: 30)).to be_valid
      end
    end

    context 'when cook_time is present' do
      it 'is invalid when cook_time is zero' do
        expect(build(:recipe, cook_time: 0)).not_to be_valid
      end

      it 'is valid when cook_time is positive' do
        expect(build(:recipe, cook_time: 45)).to be_valid
      end
    end

    context 'when servings is present' do
      it 'is invalid when servings is zero' do
        expect(build(:recipe, servings: 0)).not_to be_valid
      end

      it 'is valid when servings is positive' do
        expect(build(:recipe, servings: 4)).to be_valid
      end
    end

    it 'is valid with nil prep_time, cook_time, and servings' do
      expect(build(:recipe, prep_time: nil, cook_time: nil, servings: nil)).to be_valid
    end
  end

  describe 'scopes' do
    let!(:public_recipe) { create(:recipe, :public) }
    let!(:private_recipe) { create(:recipe, public: false) }

    describe '.public_recipes' do
      it 'returns only public recipes' do
        expect(Recipe.public_recipes).to include(public_recipe)
        expect(Recipe.public_recipes).not_to include(private_recipe)
      end
    end

    describe '.by_user' do
      it 'returns only recipes belonging to the given user' do
        expect(Recipe.by_user(public_recipe.user)).to include(public_recipe)
        expect(Recipe.by_user(public_recipe.user)).not_to include(private_recipe)
      end
    end

    describe '.tagged_with' do
      let!(:veggie_recipe) do
        r = create(:recipe, :public)
        r.tag_names = "vegetarian"
        r.save!
        r
      end
      let!(:quick_recipe) do
        r = create(:recipe, :public)
        r.tag_names = "quick"
        r.save!
        r
      end

      it 'returns only recipes with the given tag' do
        expect(Recipe.tagged_with("vegetarian")).to include(veggie_recipe)
        expect(Recipe.tagged_with("vegetarian")).not_to include(quick_recipe)
      end

      it 'is case-insensitive' do
        expect(Recipe.tagged_with("VEGETARIAN")).to include(veggie_recipe)
      end
    end

    describe '.matching_ingredients' do
      let(:garlic)  { create(:ingredient, name: "garlic") }
      let(:lemon)   { create(:ingredient, name: "lemon") }
      let(:chicken) { create(:ingredient, name: "chicken") }

      let!(:garlic_lemon_recipe) do
        r = create(:recipe, :public)
        create(:recipe_ingredient, recipe: r, ingredient: garlic)
        create(:recipe_ingredient, recipe: r, ingredient: lemon)
        r
      end

      let!(:chicken_only_recipe) do
        r = create(:recipe, :public)
        create(:recipe_ingredient, recipe: r, ingredient: chicken)
        r
      end

      it 'returns recipes that use any of the searched ingredients' do
        results = Recipe.matching_ingredients(["garlic"])
        expect(results).to include(garlic_lemon_recipe)
        expect(results).not_to include(chicken_only_recipe)
      end

      it 'returns recipes matching any ingredient in the list' do
        results = Recipe.matching_ingredients(["garlic", "chicken"])
        expect(results).to include(garlic_lemon_recipe)
        expect(results).to include(chicken_only_recipe)
      end

      it 'is case-insensitive' do
        expect(Recipe.matching_ingredients(["GARLIC"])).to include(garlic_lemon_recipe)
      end

      it 'does not return duplicates when a recipe matches multiple searched ingredients' do
        results = Recipe.matching_ingredients(["garlic", "lemon"])
        expect(results.count { |r| r.id == garlic_lemon_recipe.id }).to eq(1)
      end

      it 'returns nothing when no ingredients match' do
        expect(Recipe.matching_ingredients(["truffle"])).to be_empty
      end
    end
  end

  describe '#tag_names=' do
    let(:recipe) { create(:recipe) }

    it 'assigns tags from a comma-separated string' do
      recipe.tag_names = "vegetarian, quick"
      recipe.save!
      expect(recipe.tags.map(&:name)).to contain_exactly("vegetarian", "quick")
    end

    it 'finds existing tags rather than creating duplicates' do
      existing = create(:tag, name: "italian")
      recipe.tag_names = "italian"
      recipe.save!
      expect(recipe.tags).to include(existing)
      expect(Tag.where(name: "italian").count).to eq(1)
    end

    it 'normalises tags to lowercase' do
      recipe.tag_names = "Dairy-Free"
      recipe.save!
      expect(recipe.tags.first.name).to eq("dairy-free")
    end

    it 'replaces existing tags on reassignment' do
      recipe.tag_names = "vegetarian"
      recipe.save!
      recipe.tag_names = "quick"
      recipe.save!
      expect(recipe.tags.map(&:name)).to eq(["quick"])
    end
  end
end
