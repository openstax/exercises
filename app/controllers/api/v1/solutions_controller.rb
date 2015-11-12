module Api::V1
  class SolutionsController < OpenStax::Api::V1::ApiController

    before_filter :get_solution, only: [:show, :update, :destroy]

    resource_description do
      api_versions "v1"
      short_description 'A solution for an Exercise.'
      description <<-EOS
        Solutions teach students how to solve Exercises.
        They contain more than just the correct answer.
      EOS
    end

    #########
    # index #
    #########

    api :GET, '/exercises/:exercise_id/solutions', 'Lists the visible Solutions for the given exercise'
    description <<-EOS
      Shows the list of visible Solutions for the given exercise.

      Visible solutions include solutions written by
      the user, as well as published solutions.

      #{json_schema(Api::V1::SolutionSearchRepresenter, include: :readable)}
    EOS
    def index
      standard_index(Solution.visible_for(current_human_user),
                     represent_with: Api::V1::SolutionSearchRepresenter)
    end

    ########
    # show #
    ########

    api :GET, '/solutions/:uid', 'Gets the specified Solution'
    description <<-EOS
      Shows the specified Solution, including high-level explanation and detailed explanation.

      The user must have permission to view the solution.

      #{json_schema(Api::V1::SolutionRepresenter, include: :readable)}
    EOS
    def show
      standard_read(@solution)
    end

    ##########
    # create #
    ##########

    api :POST, '/exercises/:exercise_uid/solutions',
               'Creates a new Solution for the given exercise'
    description <<-EOS
      Creates a new Solution for the given exercise.
      The user is set as the author and copyright holder.

      #{json_schema(Api::V1::SolutionRepresenter, include: :writeable)}
    EOS
    def create
      standard_create(Solution) do |solution|
        c = solution.add_collaborator(current_human_user)
        c.is_author = true
        c.is_copyright_holder = true
      end
    end

    ##########
    # update #
    ##########

    api :PUT, '/solutions/:uid', 'Updates the properties of a Solution'
    description <<-EOS
      Updates the properties of the specified Solution.

      The user must have permission to edit the solution.

      #{json_schema(Api::V1::SolutionRepresenter, include: :writeable)}
    EOS
    def update
      standard_update(@solution)
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/solutions/:uid', 'Deletes the specified Solution'
    description <<-EOS
      Deletes the specified Solution.

      The user must have permission to edit the solution.
    EOS
    def destroy
      standard_destroy(@solution)
    end

    protected

    def get_solution
      @exercise = Solution.visible_for(current_api_user).with_uid(params[:id]).first || \
        raise(ActiveRecord::RecordNotFound,
              "Couldn't find Solution with 'uid'=#{params[:id]}")
    end

  end
end
