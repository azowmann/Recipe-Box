class MealPlanEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal_plan

  def create
    @entry = @meal_plan.meal_plan_entries.find_or_initialize_by(
      day_of_week: entry_params[:day_of_week],
      meal_type:   entry_params[:meal_type]
    )
    @entry.recipe_id = entry_params[:recipe_id]

    if @entry.save
      redirect_to meal_plan_path(@meal_plan), notice: "Meal added."
    else
      redirect_to meal_plan_path(@meal_plan), alert: @entry.errors.full_messages.to_sentence
    end
  end

  def destroy
    @meal_plan.meal_plan_entries.find(params[:id]).destroy
    redirect_to meal_plan_path(@meal_plan), notice: "Meal removed."
  end

  private

  def set_meal_plan
    @meal_plan = current_user.meal_plans.find(params[:meal_plan_id])
  end

  def entry_params
    params.require(:meal_plan_entry).permit(:day_of_week, :meal_type, :recipe_id)
  end
end
