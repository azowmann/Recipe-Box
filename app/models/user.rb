class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :pantry_items, dependent: :destroy
  has_many :pantry_ingredients, through: :pantry_items, source: :ingredient
  has_many :meal_plans, dependent: :destroy
end
