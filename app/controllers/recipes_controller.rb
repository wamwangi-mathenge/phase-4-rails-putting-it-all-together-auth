class RecipesController < ApplicationController
  before_action :authorize
  before_action :set_recipe, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_entry

    def index
      @recipes = Recipe.all
      render json: @recipes
    end

    def show
      render json: @recipe
    end

    def create
      user = User.find(session[:user_id])
      recipe = user.recipes.create!(recipe_params)
      render json: recipe, status: :created
    end


    private

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
    
    def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete)
    end 

    def authorize
      return render json: { errors: [ "Not authorized" ] }, status: :unauthorized unless session.include? :user_id
    end

    def invalid_entry(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
