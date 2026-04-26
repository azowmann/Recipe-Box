class MealPlansController < ApplicationController
  before_action :authenticate_user!

  def current
    redirect_to meal_plan_path(find_or_create_current_week_plan)
  end

  def show
    @meal_plan = find_or_create_current_week_plan
    @entries = @meal_plan.meal_plan_entries
                         .includes(:recipe)
                         .index_by { |e| [e.day_of_week, e.meal_type] }
    @recipes = current_user.recipes.order(:title)
  end

  def create
    week_start = Date.parse(params[:week_start_date])
    @meal_plan = current_user.meal_plans.find_or_create_by!(week_start_date: week_start)
    redirect_to meal_plan_path(@meal_plan)
  rescue ArgumentError, ActiveRecord::RecordInvalid
    redirect_to meal_plan_path(find_or_create_current_week_plan), alert: "Could not create meal plan."
  end

  private

  def find_or_create_current_week_plan
    current_user.meal_plans.find_or_create_by!(
      week_start_date: Date.current.beginning_of_week(:monday)
    )
  end
end
