class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.text :instructions, null: false
      t.integer :prep_time
      t.integer :cook_time
      t.integer :servings
      t.boolean :public, null: false, default: false

      t.timestamps
    end

  end
end
