module Api::V1
  class PublicationsController < OpenStax::Api::V1::ApiController

    PUBLISH_REPRESENTERS = {
      'Exercise'          => 'Api::V1::Exercises::Representer',
      'VocabTerm'         => 'Api::V1::Vocabs::TermWithDistractorsAndExerciseIdsRepresenter',
    }

    before_action :get_publishable

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

    api :PUT, '/object_name/:object_uid/publish', 'Publishes the specified object'
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
                                          responder: ResponderWithPutPatchDeleteContent,
                                          user_options: { user: current_api_user }
      else
        render_api_errors @publishable.publication.errors
      end
    end

    protected

    def get_exercise
      Exercise.visible_for(user: current_api_user).with_id(params[:exercise_id]).first ||
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Exercise with 'uid'=#{params[:exercise_id]}")
    end

    def get_vocab_term
      VocabTerm.visible_for(user: current_api_user).with_id(params[:vocab_term_id]).first ||
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find VocabTerm with 'uid'=#{params[:vocab_term_id]}")
    end

    def get_publishable
      ids = [params[:vocab_term_id], params[:exercise_id]].compact
      raise(
        ActionController::BadRequest,
        'You must provide either a vocab_term_id, or an exercise_id'
      ) if ids.size == 0
      raise(ActionController::BadRequest, 'Please publish one object at a time') if ids.size > 1

      @publishable = get_exercise           if params[:exercise_id].present?
      @publishable = get_vocab_term         if params[:vocab_term_id].present?
    end

  end
end
