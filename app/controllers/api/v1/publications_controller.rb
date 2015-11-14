module Api::V1
  class PublicationsController < OpenStax::Api::V1::ApiController

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
      @publishable.publication.publish
      @publishable.publication.save
      respond_with @publishable, responder: ResponderWithPutContent, user: current_api_user
    end

    protected

    def get_exercise
      Exercise.visible_for(current_api_user).with_uid(params[:exercise_id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Exercise with 'uid'=#{params[:exercise_id]}")
    end

    def get_solution
      Solution.visible_for(current_api_user).with_uid(params[:solution_id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Solution with 'uid'=#{params[:solution_id]}")
    end

    def get_publishable
      @publishable = params[:solution_id].nil? ? get_exercise : get_solution
    end

  end
end
