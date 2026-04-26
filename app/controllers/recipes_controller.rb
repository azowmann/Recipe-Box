class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @ingredient_query = params[:ingredients].to_s.strip
    @tag_filter = params[:tag].to_s.strip.downcase.presence

    @recipes = Recipe.public_recipes

    if @ingredient_query.present?
      @searched_names = @ingredient_query.split(",").map(&:strip).reject(&:empty?).map(&:downcase)
      @recipes = @recipes.matching_ingredients(@searched_names).includes(recipe_ingredients: :ingredient)
    end

    @recipes = @recipes.tagged_with(@tag_filter) if @tag_filter
    @recipes = @recipes.order(created_at: :desc).distinct

    @all_tags = Tag.joins(:recipes).where(recipes: { public: true }).distinct.order(:name)
  end

  def show
  end

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Recipe created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted."
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def authorize_owner!
    redirect_to recipes_path, alert: "Not authorized." unless @recipe.user == current_user
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :description, :instructions,
      :prep_time, :cook_time, :servings, :public, :photo, :tag_names
    )
  end
end
