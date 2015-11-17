module Api::V1
  class ExercisesController < OpenStax::Api::V1::ApiController

    before_filter :get_exercise_or_create_draft, only: [:show, :update]
    before_filter :get_exercise, only: [:destroy]

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

    api :GET, '/exercises', 'Return a set of Exercises matching query terms'
    description <<-EOS
      Accepts a query string along with options and returns a JSON representation
      of the matching Exercises. Only Exercises visible to the caller will be
      returned. The schema for the returned JSON result is shown below.

      #{json_schema(Api::V1::ExerciseSearchRepresenter, include: :readable)}
    EOS
    # Using route helpers doesn't work in test or production, probably has to do with initialization order
    example "#{api_example(url_base: 'https://exercises.openstax.org/api/exercises',
                           url_end: '?q=username:bob%20name=Jones')}"
    param :q, String, required: true, desc: <<-EOS
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
      * `published_before` &ndash; Matches exercises published before the given date.
                                   Enclose date in quotes to avoid parsing errors.

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
      A string that indicates how to sort the results of the query. The string
      is a comma-separated list of fields with an optional sort direction. The
      sort will be performed in the order the fields are given.
      The fields can be one of #{
        SearchExercises::SORTABLE_FIELDS.keys.collect{|sf| "`"+sf+"`"}.join(', ')
      }.
      Sort directions can either be `ASC` for
      an ascending sort, or `DESC` for a
      descending sort. If not provided, an ascending sort is assumed. Sort
      directions should be separated from the fields by a space.
      (default: `number ASC`)

      Example:

      `number, version DESC` &ndash; sorts by number ascending, then by version descending
    EOS
    def index
      standard_search(Exercise, SearchExercises, ExerciseSearchRepresenter, user: current_api_user)
    end

    ##########
    # create #
    ##########

    api :POST, '/exercises', 'Creates an Exercise'
    description <<-EOS
      Creates an Exercise with the given attributes.

      #{json_schema(Api::V1::ExerciseRepresenter, include: :writeable)}
    EOS
    def create
      user = current_human_user
      standard_create(Exercise.new, nil, user: current_api_user) do |exercise|
        exercise.publication.authors << Author.new(
          publication: exercise.publication, user: user
        ) unless exercise.publication.authors.any?{ |a| a.user = user }
        exercise.publication.copyright_holders << CopyrightHolder.new(
          publication: exercise.publication, user: user
        ) unless exercise.publication.copyright_holders
                                     .any?{ |a| a.user = user }
      end
    end

    ########
    # show #
    ########

    api :GET, '/exercises/:uid', 'Gets the specified Exercise'
    description <<-EOS
      Gets the Exercise that matches the provided UID.

      #{json_schema(Api::V1::ExerciseRepresenter, include: :readable)}
    EOS
    def show
      standard_read(@exercise, nil, false, user: current_api_user)
    end

    ##########
    # update #
    ##########

    api :PUT, '/exercises/:uid', 'Updates the specified Exercise'
    description <<-EOS
      Updates the Exercise that matches the provided UID with the given attributes.

      #{json_schema(Api::V1::ExerciseRepresenter, include: :writeable)}
    EOS
    def update
      standard_update(@exercise, nil, user: current_api_user)
    end

    ###########
    # destroy #
    ###########

    api :DELETE, '/exercises/:uid', 'Deletes the specified Exercise'
    description <<-EOS
      Deletes the Exercise that matches the provided UID.
    EOS
    def destroy
      standard_destroy(@exercise)
    end

    protected

    def get_exercise
      @exercise = Exercise.visible_for(current_api_user).with_uid(params[:id]).first || \
        raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{params[:id]}")
    end

    def get_exercise_or_create_draft
      @exercise = Exercise.visible_for(current_api_user).with_uid(params[:id]).first
      return unless @exercise.nil?

      @number, @version = params[:id].split('@')
      draft_requested = @version == 'draft' || @version == 'd'
      raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{params[:id]}") \
        unless draft_requested

      published_exercise = Exercise.visible_for(current_api_user).with_uid(@number).first || \
        raise(ActiveRecord::RecordNotFound, "Couldn't find Exercise with 'uid'=#{params[:id]}")
      @exercise = published_exercise.new_version
      @exercise.save!
    end

  end
end
