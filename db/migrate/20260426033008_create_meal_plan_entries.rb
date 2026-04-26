class CreateMealPlanEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_plan_entries do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.string :meal_type, null: false

      t.timestamps
    end

    add_index :meal_plan_entries, [:meal_plan_id, :day_of_week, :meal_type], unique: true, name: "index_meal_plan_entries_on_slot"
  end
end
