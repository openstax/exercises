module Api::V1
  class PublicationsController < OpenStax::Api::V1::ApiController

    PUBLISH_REPRESENTERS = {
      'CommunitySolution' => 'Api::V1::CommunitySolutionRepresenter',
      'Exercise' => 'Api::V1::ExerciseRepresenter',
      'VocabTerm' => 'Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter',
    }

    before_filter :get_publishable

    resource_description do
      api_versions "v1"
      short_description 'Contains information about a publishable object.'
      description <<-EOS
        Publications contain information about the publication status of
        publishable objects, such as Exercises, Solutions and code Libraries.
      EOS
    end

    ###########
    # publish #
    ###########

    api :PUT, '/object/:object_uid/publish',
               'Publishes the specified object'
    description <<-EOS
      Publishes the specified object.
    EOS
    def publish
      OSU::AccessPolicy.require_action_allowed!(
        :publish, current_api_user, @publishable.publication
      )

      if @publishable.publication.publish.save
        representer = PUBLISH_REPRESENTERS[@publishable.class.name].classify.constantize

        respond_with @publishable.reload, represent_with: representer,
                                          responder: ResponderWithPutContent,
                                          user: current_api_user
      else
        render_api_errors @publishable.publication.errors
      end
    end

    protected

    def get_exercise
      Exercise.visible_for(current_api_user).with_uid(params[:exercise_id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Exercise with 'uid'=#{params[:exercise_id]}")
    end

    def get_vocab_term
      VocabTerm.visible_for(current_api_user).with_uid(params[:vocab_term_id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find VocabTerm with 'uid'=#{params[:vocab_term_id]}")
    end

    def get_community_solution
      CommunitySolution.visible_for(current_api_user)
                       .with_uid(params[:community_solution_id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Solution with 'uid'=#{params[:community_solution_id]}")
    end

    def get_publishable
      ids = [params[:community_solution_id], params[:vocab_term_id], params[:exercise_id]].compact
      raise(ActionController::BadRequest, 'You must provide either a community_solution_id, ' +
                                          'a vocab_term_id or an exercise_id') if ids.size == 0
      raise(ActionController::BadRequest, 'Please publish one object at a time') if ids.size > 1

      @publishable = get_community_solution if params[:community_solution_id].present?
      @publishable = get_exercise           if params[:exercise_id].present?
      @publishable = get_vocab_term         if params[:vocab_term_id].present?
    end

  end
end
