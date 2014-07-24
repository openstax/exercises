module Api
  module V1

    class ExercisesController < OpenStax::Api::V1::ApiController 

      resource_description do
        api_versions "v1"
        short_description 'Exercises are the containers for all information related to an exercise'
        description <<-EOS
          Exercises are ...
        EOS
      end

      ###############################################################
      # index
      ###############################################################

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

        * `content` &ndash; Matches the content of exercises. (uses wildcard matching)
        * `solution` &ndash; Matches the content of the exercises' solutions.
                             (uses wildcard matching)
        * `author` &ndash; Matches authors' first, last, or full names, case insenstive. (uses wildcard matching)
        * `copyright_holder` &ndash; Matches copyright holders' first, last, or full names, case insenstive. (uses wildcard matching)
        * `number` &ndash; Matches exercise numbers exactly.
        * `version` &ndash; Matches exercise versions exactly.
        * `id` &ndash; Matches exercise IDs exactly.

        You can also add search terms without prefixes, separated by spaces.
        These terms will be searched for in all of the prefix categories.
        Any matching exercises will be returned. When combined with prefixed search
        terms, the final results will contain exercises matching any of the non
        prefixed terms and all of the prefixed terms.

        Examples:

        `content:DTFT` &ndash; returns exercises containing the DTFT word.

        `number:1 version:2` &ndash; returns e1v2.
      EOS
      param :order_by, String, desc: <<-EOS
        A string that indicates how to sort the results of the query. The string
        is a comma-separated list of fields with an optional sort direction. The
        sort will be performed in the order the fields are given.
        The fields can be one of #{SearchExercises::SORTABLE_FIELDS.collect{|sf| "`"+sf+"`"}.join(', ')}.
        Sort directions can either be `ASC` for 
        an ascending sort, or `DESC` for a
        descending sort. If not provided, an ascending sort is assumed. Sort
        directions should be separated from the fields by a space.
        (default: `number ASC`)

        Example:

        `number, version DESC` &ndash; sorts by number ascending, then by version descending
      EOS
      def index
        OSU::AccessPolicy.require_action_allowed!(:index, current_user, Exercise)
        outputs = OpenStax::Exercises::SearchExercises.call(params[:q], params.slice(:order_by)).outputs
        respond_with outputs, represent_with: Api::V1::ExerciseSearchRepresenter
      end

      ###############################################################
      # show
      ###############################################################

      api :GET, '/exercises/:id', 'Gets the specified Exercise'
      description <<-EOS
        #{json_schema(Api::V1::ExerciseRepresenter, include: :readable) if true}        
      EOS
      def show
        standard_read(Exercise, params[:id])
      end

      ###############################################################
      # update
      ###############################################################

      api :PUT, '/exercises/:id', 'Updates the specified Exercise'
      description <<-EOS
        Updates the Exercise object whose ID matches the provided param.  Any provided 
        transformed Content field (e.g. 'html') will be ignored.

        #{json_schema(Api::V1::ExerciseRepresenter, include: :writeable)}        
      EOS
      def update
        standard_update(Exercise, params[:id])
      end
      
    end
  end
end