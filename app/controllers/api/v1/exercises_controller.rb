module Api::V1
  class ExercisesController < OpenStax::Api::V1::ApiController

    include ::Exercises::Finders

    before_action :find_exercise_or_create_draft, only: [:show, :update]
    before_action :find_exercise, only: [:destroy]

    resource_description do
      api_versions "v1"
      short_description 'A collection of related questions.'
      description <<-EOS
        Exercises are collections of related questions about a very specific situation or topic, possibly united by a common background story.
      EOS
    end

    #########
    # index #
    #########

    api :GET, '/exercises'        , 'Return a set of Exercises matching query terms'
    api :GET, '/exercises/search' , 'Return a set of Exercises matching query terms'
    api :POST, '/exercises/search', 'Return a set of Exercises matching query terms'
    description <<-EOS
      Accepts a query string along with options and returns a JSON representation
      of the matching Exercises. Only Exercises visible to the caller will be
      returned. The schema for the returned JSON result is shown below.

      #{json_schema(Api::V1::Exercises::SearchRepresenter, include: :readable)}
    EOS
    # Using route helpers doesn't work in test or production, probably has to do with initialization order
    example "#{api_example(url_base: 'https://exercises.openstax.org/api/exercises',
                           url_end: '?q=author:"bob" content:"test"')}"
    param :q, String, desc: <<-EOS
      The search query string, built up as a space-separated collection of
      search conditions on different fields. Each condition is formatted as
      "field_name:comma-separated-values". The resulting list of exercises will
      match all of the conditions (boolean 'and'). Each condition will produce
      a list of exercises where those exercises must match any of the
      comma-separated-values (boolean 'or'). The fields_names and their
      characteristics are given below.
      When a field is listed as using wildcard matching, it means that any
      fields that start with a comma-separated-value will be matched.

      * `content` &ndash; Matches the exercise content. (uses wildcard matching)
      * `solution` &ndash; Matches the exercise solution content.
                           (uses wildcard matching)
      * `author` &ndash; Matches authors' and copyright holders' first, last, or full names.
                         (uses wildcard matching)
      * `number` &ndash; Matches the exercise number exactly.
      * `version` &ndash; Matches the exercise version exactly.
      * `id` &ndash; Matches the exercise ID or UID exactly.

      You can also add search terms without prefixes, separated by spaces.
      These terms will be searched for in all of the prefix categories.
      Any matching exercises will be returned. When combined with prefixed search
      terms, the final results will contain exercises matching any of the non
      prefixed terms and all of the prefixed terms.

      Examples:

      `content:DTFT` &ndash; returns exercises containing the DTFT word.

      `number:1 version:2` &ndash; returns exercise 1@2.
    EOS
    param :order_by, String, desc: <<-EOS
      A string that indicates how to sort the results of the query.
      The string is a comma-separated list of fields with an optional sort direction.
      The sort will be performed in the order the fields are given.
      The fields can be one of #{
        SearchExercises::SORTABLE_FIELDS.keys.map { |sf| "`"+sf+"`" }.join(', ')
      }.
      Sort directions can either be `ASC` for an ascending sort, or `DESC` for a descending sort.
      If not provided, an ascending sort is assumed.
      Sort directions should be separated from the fields by a space. (default: `number ASC`)

      Example:

      `number, version DESC` &ndash; sorts by number ascending, then by version descending
    EOS
    def index
      ScoutHelper.ignore! 0.99

      standard_search(
        Exercise, SearchExercises, Exercises::SearchRepresenter, user: current_api_user
      ) do |outputs|
        digest = Digest::SHA256.new
        outputs.items.each { |exercise| digest << exercise.cache_key_with_version }
        response.headers['X-Digest'] = digest.hexdigest
      end
    end

    ##########
    # create #
    ##########

    api :POST, '/exercises', 'Creates an Exercise'
    description <<-EOS
      Creates an Exercise with the given attributes.

      #{json_schema(Api::V1::Exercises::Representer, include: :writeable)}
    EOS
    def create
      exercise = Exercise.new
      user = current_human_user

      create_options = { status: :created, location: nil }
      represent_with_options = {
        user_options: { user: current_api_user }, represent_with: Api::V1::Exercises::Representer
      }

      Exercise.transaction do
        consume!(exercise, represent_with_options.dup)

        publication = exercise.publication

        existing_authors = publication.authors.map(&:user)
        (user.default_authors - existing_authors).each do |au|
          publication.authors << Author.new(publication: publication, user: au)
        end

        existing_copyright_holders = publication.copyright_holders.map(&:user)
        (user.default_copyright_holders - existing_copyright_holders).each do |ch|
          publication.copyright_holders << CopyrightHolder.new(publication: publication, user: ch)
        end

        publication_group = publication.publication_group

        OSU::AccessPolicy.require_action_allowed!(:create, current_api_user, exercise)

        if publication.save && publication_group.save && exercise.save
          respond_with exercise, create_options.merge(represent_with_options)
        else
          render_api_errors(publication.errors) ||
          render_api_errors(publication_group.errors) ||
          render_api_errors(exercise.errors)
          raise ActiveRecord::Rollback
        end
      end
    end

    ########
    # show #
    ########

    api :GET, '/exercises/:uid', 'Gets the specified Exercise'
    description <<-EOS
      Gets the Exercise that matches the provided UID.

      #{json_schema(Api::V1::Exercises::Representer, include: :readable)}
    EOS
    def show
      standard_read(@exercise, Api::V1::Exercises::Representer, false, user: current_api_user)
    end

    ##########
    # update #
    ##########

    api :PUT, '/exercises/:uid', 'Updates the specified Exercise'
    description <<-EOS
      Updates the Exercise that matches the provided UID with the given attributes.

      #{json_schema(Api::V1::Exercises::Representer, include: :writeable)}
    EOS
    def update
      OSU::AccessPolicy.require_action_allowed!(:update, current_api_user, @exercise)

      represent_with_options = {
        user_options: { user: current_api_user }, represent_with: Api::V1::Exercises::Representer
      }

      @exercise.with_lock do
        consume!(@exercise, represent_with_options.dup)

        publication_group = @exercise.publication.publication_group
        if @exercise.save && publication_group.save
          respond_with @exercise,
                       represent_with_options.merge(responder: ResponderWithPutPatchDeleteContent)
        else
          render_api_errors(publication_group.errors) || render_api_errors(@exercise.errors)
          raise ActiveRecord::Rollback
        end
      end
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/exercises/:uid', 'Deletes the specified Exercise'
    description <<-EOS
      Deletes the Exercise that matches the provided UID.
    EOS
    def destroy
      standard_destroy(@exercise, Api::V1::Exercises::Representer, user: current_api_user)
    end

  end
end
