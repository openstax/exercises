module Api::V1
  class DeputizationsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'A deputy.'
      description <<-EOS
        Deputies represent users that can act on behalf of the deputizer in OpenStax Exercises. 
      EOS
    end

    #########
    # index #
    #########

    api :GET, '/user/deputies', 'Gets a list of deputies for the current user'
    description <<-EOS
      Gets a list of deputies for the current user.

      #{json_schema(Api::V1::DeputizationRepresenter, include: :readable)}        
    EOS
    def index
      current_human_user.child_deputizations
    end

    ##########
    # create #
    ##########

    api :POST, '/user/deputies/:deputy_type/:deputy_id', 'Adds a deputy for the current user'
    description <<-EOS
      Adds a deputy for the current user.

      #{json_schema(Api::V1::DeputizationRepresenter, include: :writeable)}        
    EOS
    def create
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/user/deputies/:deputy_type/:deputy_id', 'Deletes the given deputy for the current user'
    description <<-EOS
      Deletes the given deputy for the current user.    
    EOS
    def destroy
    end

  end
end
