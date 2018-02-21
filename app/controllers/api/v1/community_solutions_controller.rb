module Api::V1
  class CommunitySolutionsController < OpenStax::Api::V1::ApiController

    before_filter :get_community_solution, only: [:show, :update, :destroy]

    resource_description do
      api_versions "v1"
      short_description 'A solution for an Exercise.'
      description <<-EOS
        Solutions teach students how to solve Exercises.
        They contain more than just the correct answer.
      EOS
    end

    ########
    # show #
    ########

    api :GET, '/community_solutions/:uid', 'Gets the specified CommunitySolution'
    description <<-EOS
      Shows the specified CommunitySolution.

      The user must have permission to view it.

      #{json_schema(Api::V1::Exercises::CommunitySolutionRepresenter, include: :readable)}
    EOS
    def show
      standard_read(@community_solution)
    end

    ##########
    # create #
    ##########

    api :POST, '/exercises/:exercise_uid/community_solutions',
               'Creates a new CommunitySolution for the given exercise'
    description <<-EOS
      Creates a new CommunitySolution for the given exercise.

      The user is set as its author and copyright holder.

      #{json_schema(Api::V1::Exercises::CommunitySolutionRepresenter, include: :writeable)}
    EOS
    def create
      standard_create(CommunitySolution) do |community_solution|
        collaborator = community_solution.add_collaborator(current_human_user)
        collaborator.is_author = true
        collaborator.is_copyright_holder = true
      end
    end

    ##########
    # update #
    ##########

    api :PUT, '/community_solutions/:uid', 'Updates the properties of a CommunitySolution'
    description <<-EOS
      Updates the properties of the specified CommunitySolution.

      The user must have permission to edit it.

      #{json_schema(Api::V1::Exercises::CommunitySolutionRepresenter, include: :writeable)}
    EOS
    def update
      standard_update(@community_solution)
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/community_solutions/:uid', 'Deletes the specified CommunitySolution'
    description <<-EOS
      Deletes the specified CommunitySolution.

      The user must have permission to edit it.
    EOS
    def destroy
      standard_destroy(@community_solution)
    end

    protected

    def get_community_solution
      @community_solution = CommunitySolution.visible_for(user: current_api_user)
                                             .with_id(params[:id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find CommunitySolution with 'uid'=#{params[:id]}")
    end

  end
end
