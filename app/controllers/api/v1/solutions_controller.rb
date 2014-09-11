module Api::V1
  class SolutionsController < OpenStax::Api::V1::ApiController

    resource_description do
      api_versions "v1"
      short_description 'Represents a solution for an Exercise.'
      description <<-EOS
        Solutions teach Users how to solve an Exercise.
      EOS
    end

    ###############################################################
    # index
    ###############################################################

    api :GET, '/exercises/:exercise_id/solutions', 'Lists the Solutions for the given exercise visible to the current user.'
    description <<-EOS
      Shows the list the Solutions for the given exercise visible to the current user

      This includes solutions written by the current user,
      as well as published solutions.

      #{json_schema(Api::V1::SolutionsRepresenter, include: :readable)}
    EOS
    def index
      respond_with Solution.visible_for(current_human_user)
    end

    ###############################################################
    # create
    ###############################################################

    api :POST, '/exercises/:exercise_id/solutions', 'Creates a new Solution for the given exercise.'
    description <<-EOS
      Creates a new Solution for the given exercise and sets the current user as the author and copyright holder.

      #{json_schema(Api::V1::SolutionRepresenter, include: :writeable)}
    EOS
    def create
      standard_create(Solution) do |solution|
        c = solution.add_collaborator(current_human_user)
        c.is_author = true
        c.is_copyright_holder = true
      end
    end

    ###############################################################
    # show
    ###############################################################

    api :GET, '/solutions/:id', 'Gets the specified Solution.'
    description <<-EOS
      Shows the specified Solution, including high-level explanation and detailed explanation.

      Anyone can see published solutions,
      but only collaborators can see private solutions.

      #{json_schema(Api::V1::SolutionRepresenter, include: :readable)}
    EOS
    def show
      standard_read(Solution, params[:id])
    end

    ###############################################################
    # update
    ###############################################################

    api :PUT, '/solutions/:id', 'Updates the properties of a Solution.'
    description <<-EOS
      Updates the properties of the specified Solution.

      Requires the current user to be an owner of the solution.

      #{json_schema(Api::V1::SolutionRepresenter, include: :writeable)}
    EOS
    def update
      standard_update(Solution, params[:id])
    end

    ###############################################################
    # destroy
    ###############################################################

    api :DELETE, '/solutions/:id', 'Deletes the specified Solution.'
    description <<-EOS
      Deletes the specified Solution.

      Requires the current user to be an owner of the solution.
    EOS
    def destroy
      standard_destroy(Solution, params[:id])
    end

  end
end
