class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :meal_plan_entries, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_one_attached :photo

  validates :title, presence: true
  validates :instructions, presence: true
  validates :public, inclusion: { in: [true, false] }
  validates :prep_time, numericality: { greater_than: 0, allow_nil: true }
  validates :cook_time, numericality: { greater_than: 0, allow_nil: true }
  validates :servings, numericality: { greater_than: 0, allow_nil: true }

  scope :public_recipes, -> { where(public: true) }
  scope :by_user, ->(user) { where(user: user) }
  scope :tagged_with, ->(tag_name) {
    joins(:tags).where("LOWER(tags.name) = ?", tag_name.downcase)
  }

  scope :matching_ingredients, ->(names) {
    joins(:ingredients)
      .where("LOWER(ingredients.name) IN (?)", names.map(&:downcase))
      .distinct
  }

  def tag_names
    tags.map(&:name).join(", ")
  end

  def tag_names=(csv)
    names = csv.to_s.split(",").map(&:strip).reject(&:empty?).map(&:downcase).uniq
    self.tags = names.map { |name| Tag.find_or_create_by!(name: name) }
  end
end
