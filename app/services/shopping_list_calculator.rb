class ShoppingListCalculator
  def initialize(meal_plan:, user:)
    @meal_plan = meal_plan
    @user = user
  end

  def call
    aggregate_required
      .reject { |(ingredient_id, _unit), _| owned_ingredient_ids.include?(ingredient_id) }
      .values
      .sort_by { |item| item[:ingredient].name }
  end

  private

  def aggregate_required
    required_recipe_ingredients.each_with_object({}) do |ri, hash|
      key = [ri.ingredient_id, ri.unit]
      hash[key] ||= { ingredient: ri.ingredient, quantity: 0.0, unit: ri.unit }
      hash[key][:quantity] += ri.quantity.to_f
    end
  end

  # Grouped by [ingredient_id, unit] so same ingredient with different units
  # stays on separate rows — no implicit unit conversion.
  def required_recipe_ingredients
    @meal_plan.meal_plan_entries
              .includes(recipe: { recipe_ingredients: :ingredient })
              .flat_map { |entry| entry.recipe.recipe_ingredients }
  end

  def owned_ingredient_ids
    @owned_ingredient_ids ||= @user.pantry_items.pluck(:ingredient_id).to_set
  end
end
