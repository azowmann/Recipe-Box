class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_name

  private

  def normalize_name
    self.name = name.strip.downcase
  end
end
