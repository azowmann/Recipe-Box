class ShoppingListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal_plan

  def show
    @shopping_list = ShoppingListCalculator.new(meal_plan: @meal_plan, user: current_user).call
  end

  private

  def set_meal_plan
    @meal_plan = current_user.meal_plans.find(params[:meal_plan_id])
  end
end
