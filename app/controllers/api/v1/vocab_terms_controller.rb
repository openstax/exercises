module Api::V1
  class VocabTermsController < OpenStax::Api::V1::ApiController

    before_filter :get_vocab_term_or_create_draft, only: [:show, :update]
    before_filter :get_vocab_term, only: :destroy

    resource_description do
      api_versions "v1"
      short_description 'A vocabulary term, its definition and distractors'
      description <<-EOS
        Vocabulary terms represent a word or phrase, its definition and related distractor terms or definitions.
      EOS
    end

    #########
    # index #
    #########

    api :GET, '/vocab_terms', 'Return a set of VocabTerms matching query terms'
    description <<-EOS
      Accepts a query string along with options and returns a JSON representation
      of the matching VocabTerms. Only VocabTerms visible to the caller will be
      returned. The schema for the returned JSON result is shown below.

      #{json_schema(Api::V1::VocabTermSearchRepresenter, include: :readable)}
    EOS
    # Using route helpers doesn't work in test or production, probably has to do with initialization order
    example "#{api_example(url_base: 'https://exercises.openstax.org/api/vocab_terms',
                           url_end: '?q=name:"term" definition:"def"')}"
    param :q, String, required: true, desc: <<-EOS
      The search query string, built up as a space-separated collection of
      search conditions on different fields. Each condition is formatted as
      "field_name:comma-separated-values". The resulting list of vocab_terms will
      match all of the conditions (boolean 'and'). Each condition will produce
      a list of vocab terms where those vocab terms must match any of the
      comma-separated-values (boolean 'or'). The fields_names and their
      characteristics are given below.
      When a field is listed as using wildcard matching, it means that any
      fields that start with a comma-separated-value will be matched.

      * `name` &ndash; Matches the vocab term itself. (uses wildcard matching)
      * `definition` &ndash; Matches the vocab term definition. (uses wildcard matching)
      * `content` &ndash; Matches the vocab term or its definition. (uses wildcard matching)
      * `author` &ndash; Matches authors' and copyright holders' first, last, or full names.
                         (uses wildcard matching)
      * `number` &ndash; Matches the vocab term number exactly.
      * `version` &ndash; Matches the vocab term version exactly.
      * `id` &ndash; Matches the vocab term ID or UID exactly.
      * `published_before` &ndash; Matches vocab terms published before the given date.
                                   Enclose date in quotes to avoid parsing errors.

      You can also add search terms without prefixes, separated by spaces.
      These terms will be searched for in all of the prefix categories.
      Any matching vocab terms will be returned. When combined with prefixed search
      terms, the final results will contain vocab terms matching any of the non
      prefixed terms and all of the prefixed terms.

      Examples:

      `content:DTFT` &ndash; returns vocab terms containing the DTFT word.

      `number:1 version:2` &ndash; returns vocab term 1@2.
    EOS
    param :order_by, String, desc: <<-EOS
      A string that indicates how to sort the results of the query. The string
      is a comma-separated list of fields with an optional sort direction. The
      sort will be performed in the order the fields are given.
      The fields can be one of #{
        SearchVocabTerms::SORTABLE_FIELDS.keys.collect{|sf| "`"+sf+"`"}.join(', ')
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
      # This is the same code as standard_search,
      # except it doesn't enforce read access for each vocab term
      # since we only return a subset of the attributes here
      user = current_api_user
      OSU::AccessPolicy.require_action_allowed!(:search, user, VocabTerm)

      options = {user: user}
      result = SearchVocabTerms.call(params, options)
      return render_api_errors(result.errors) if result.errors.any?

      respond_with result.outputs, options.merge(represent_with: VocabTermSearchRepresenter)
    end

    ##########
    # create #
    ##########

    api :POST, '/vocab_terms', 'Creates a VocabTerm'
    description <<-EOS
      Creates a VocabTerm with the given attributes.

      #{json_schema(Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                    include: :writeable)}
    EOS
    def create
      user = current_human_user
      standard_create(VocabTerm.new, Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                      user: current_api_user) do |vocab_term|
        vocab_term.publication.authors << Author.new(
          publication: vocab_term.publication, user: user
        ) unless vocab_term.publication.authors.any?{ |a| a.user = user }
        vocab_term.publication.copyright_holders << CopyrightHolder.new(
          publication: vocab_term.publication, user: user
        ) unless vocab_term.publication.copyright_holders.any?{ |a| a.user = user }
      end
    end

    ########
    # show #
    ########

    api :GET, '/vocab_terms/:uid', 'Gets the specified VocabTerm'
    description <<-EOS
      Gets the VocabTerm that matches the provided UID.

      #{json_schema(Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                    include: :readable)}
    EOS
    def show
      standard_read(@vocab_term, Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                    false, user: current_api_user)
    end

    ##########
    # update #
    ##########

    api :PUT, '/vocab_terms/:uid', 'Updates the specified VocabTerm'
    description <<-EOS
      Updates the VocabTerm that matches the provided UID with the given attributes.

      #{json_schema(Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                    include: :writeable)}
    EOS
    def update
      standard_update(@vocab_term, Api::V1::VocabTermWithDistractorsAndExerciseIdsRepresenter,
                      user: current_api_user)
    end



    ###########
    # destroy #
    ###########

    api :DELETE, '/vocab_terms/:uid', 'Deletes the specified VocabTerm'
    description <<-EOS
      Deletes the VocabTerm that matches the provided UID.
    EOS
    def destroy
      standard_destroy(@vocab_term)
    end

    protected

    def get_vocab_term
      @vocab_term = VocabTerm.visible_for(current_api_user).with_uid(params[:id]).first || \
        raise(ActiveRecord::RecordNotFound, "Couldn't find VocabTerm with 'uid'=#{params[:id]}")
    end

    def get_vocab_term_or_create_draft
      VocabTerm.transaction do
        @number, @version = params[:id].split('@')
        draft_requested = @version == 'draft' || @version == 'd'

        # If a draft has been requested, lock the latest published vocab_term first
        # so we don't create 2 drafts
        published_vocab_term = VocabTerm.published.with_uid(@number).lock.first \
          if draft_requested

        # Attempt to find existing vocab_term
        @vocab_term = VocabTerm.visible_for(current_api_user).with_uid(params[:id]).first
        return unless @vocab_term.nil?

        # VocabTerm not found and either draft not requested or
        # no published_vocab_term so we can't create a draft
        raise(ActiveRecord::RecordNotFound, "Couldn't find VocabTerm with 'uid'=#{params[:id]}") \
          if published_vocab_term.nil?

        # Check for permission to create the draft
        OSU::AccessPolicy.require_action_allowed!(
          :new_version, current_api_user, published_vocab_term
        )

        # Draft requested and published vocab_term found
        @vocab_term = published_vocab_term.new_version
        @vocab_term.save!
      end
    end

  end
end
