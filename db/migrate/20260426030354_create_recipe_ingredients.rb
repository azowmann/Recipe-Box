class CreateRecipeIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :quantity, null: false, precision: 8, scale: 2
      t.string :unit, null: false

      t.timestamps
    end

    add_index :recipe_ingredients, [:recipe_id, :ingredient_id], unique: true
  end
end
