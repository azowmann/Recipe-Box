class Tag < ApplicationRecord
  has_many :recipe_tags, dependent: :destroy
  has_many :recipes, through: :recipe_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save { self.name = name.strip.downcase }
end
