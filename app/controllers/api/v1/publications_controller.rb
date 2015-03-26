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

    api :PUT, '/object/:object_id/publish',
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
      respond_with @publishable, responder: ResponderWithPutContent
    end

    protected

    def get_publishable
      @publishable = params[:solution_id].nil? ? \
                       Exercise.find(params[:exercise_id]) : \
                       Solution.find(params[:solution_id])
    end

  end
end
