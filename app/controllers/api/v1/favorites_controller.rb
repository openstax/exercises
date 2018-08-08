module Api::V1
  class FavoritesController < OpenStax::Api::V1::ApiController

    api :POST, '/favorites', 'Favorites a publication'
    def create
      # number, version = params[:publication].split('@')
      exercise = Exercise.visible_for(user: current_api_user).find do |e|
        e.uid == params[:publication]
      end
      publication =exercise.publication
      # publication = Publication.visible_for(user: current_api_user).where(publishable_id: exercise[:id]).first
      # logger.info publication[:id]
      # logger.info publication[:id].class
      @favorite = Favorite.new(
        publication: publication,
        user: current_human_user
      )
      if @favorite.save
        respond_with @favorite, represent_with: Api::V1::FavoriteRepresenter, location: nil
      else
        render_api_errors(@favorite.errors)
        raise ActiveRecord::Rollback
      end
    end
  end
end