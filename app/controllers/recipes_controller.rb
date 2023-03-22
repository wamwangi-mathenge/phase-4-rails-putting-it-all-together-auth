class RecipesController < ApplicationController
    def index
        if session[:user_id]
          recipes = Recipe.all.includes(:user).select(:id, :title, :instructions, :minutes_to_complete, 'users.username', 'users.image_url', 'users.bio')
          render json: recipes.as_json(only: [:username, :image_url, :bio]), status: :ok
        else
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
    end

    def create
        if session[:user_id]
          recipe = Recipe.new(recipe_params)
          recipe.user_id = session[:user_id]
    
          if recipe.valid?
            recipe.save
            render json: recipe.as_json(only: [:username, :image_url, :bio]), status: :created
          else
            render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end
    
      private
    
      def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
      end 
    
   
end
