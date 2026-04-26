require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:recipe_tags).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:recipe_tags) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it 'is invalid when name is a duplicate (case-insensitive)' do
      create(:tag, name: "vegetarian")
      expect(build(:tag, name: "Vegetarian")).not_to be_valid
    end
  end

  describe 'name normalization' do
    it 'strips and downcases before save' do
      tag = create(:tag, name: "  Italian  ")
      expect(tag.reload.name).to eq("italian")
    end
  end
end
