module Api::V1
  class UsersSwagger
    include ::Swagger::Blocks
    include OpenStax::Swagger::SwaggerBlocksExtensions

    DEFAULT_HIGHLIGHTS_PER_PAGE = 15
    MAX_HIGHLIGHTS_PER_PAGE = 200
    DEFAULT_HIGHLIGHTS_PAGE = 1

    VALID_HIGHLIGHT_COLORS = %w(yellow green blue purple pink)
    VALID_SETS = %w(user:me curated:openstax)

    swagger_schema :TextPositionSelector do
      key :required, [:type, :start, :end]
      property :start do
        key :type, :string
        key :description, 'The start to the text position selector.'
      end
      property :end do
        key :type, :string
        key :description, 'The end to the text position selector.'
      end
      property :type do
        key :type, :string
        key :description, 'The type for the text position selector.'
      end
    end

    swagger_schema :XpathRangeSelector do
      key :required, [:end_container, :end_offset, :start_container, :start_offset, :type]
      property :end_container do
        key :type, :string
        key :description, 'The end container for the xpath range selector.'
      end
      property :end_offset do
        key :type, :integer
        key :description, 'The end offset for the xpath range selector.'
      end
      property :start_container do
        key :type, :string
        key :description, 'The start container for the xpath range selector.'
      end
      property :start_offset do
        key :type, :integer
        key :description, 'The start offset for the xpath range selector.'
      end
      property :type do
        key :type, :string
        key :description, 'The type for the xpath range selector.'
      end
    end

    swagger_schema :Highlights do
      # organization from https://jsonapi.org/
      property :meta do
        property :page do
          key :type, :integer
          key :description, 'The current page number for these paginated results, one-indexed.'
        end
        property :per_page do
          key :type, :integer
          key :description, 'The requested number of results per page.'
        end
        property :count do
          key :type, :integer
          key :description, 'The number of results in the current page.'
        end
        property :total_count do
          key :type, :integer
          key :description, 'The number of results across all pages.'
        end
      end
      property :data do
        key :type, :array
        key :description, 'The filtered highlights.'
        items do
          key :'$ref', :Highlight
        end
      end
    end

    swagger_schema :ColorCount do
      key :type, :object
    end
    add_properties(:ColorCount) do
      property :yellow do
        key :type, :integer
        key :description, 'The count for yellow'
      end
      property :green do
        key :type, :integer
        key :description, 'The count for green'
      end
      property :blue do
        key :type, :integer
        key :description, 'The count for blue'
      end
      property :purple do
        key :type, :integer
        key :description, 'The count for purple'
      end
      property :pink do
        key :type, :integer
        key :description, 'The count for pink'
      end
    end

    swagger_schema :HighlightsSummary do
      property :counts_per_source do
        key :type, :object
        key :description, 'Map of source ID to number of highlights by color in that source'
        key :additionalProperties, {
          '$ref' => '#/definitions/ColorCount',
        }
      end
    end

    COMMON_REQUIRED_HIGHLIGHT_FIELDS = [
      :source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies
    ]

    swagger_schema :Highlight do
      key :required, COMMON_REQUIRED_HIGHLIGHT_FIELDS | [:id]
    end

    swagger_schema :NewHighlight do
      key :required, COMMON_REQUIRED_HIGHLIGHT_FIELDS
    end

    add_properties(:Highlight, :NewHighlight) do
      property :id do
        key :type, :string
        key :format, 'uuid'
        key :description, 'The highlight ID.'
      end
      property :source_type do
        key :type, :string
        key :enum, ['openstax_page']
        key :description, 'The type of content that contains the highlight.'
      end
      property :source_id do
        key :type, :string
        key :pattern, /^[^,]+$/
        key :description, 'The ID of the source document in which the highlight is made.  ' \
                          'Has source_type-specific constraints (e.g. all lowercase UUID for ' \
                          'the \'openstax_page\' source_type).  Because source_ids are passed ' \
                          'to query endpoints as comma-separated values, they cannot contain ' \
                          'commas.'
      end
      property :scope_id do
        key :type, :string
        key :description, 'The ID of the container for the source in which the highlight is made.  ' \
                          'Varies depending on source_type (e.g. is the lowercase, versionless ' \
                          'book UUID for the \'openstax_page\' source_type).'
      end
      property :prev_highlight_id do
        key :type, :string
        key :format, 'uuid'
        key :description, 'The ID of the highlight immediately before this highlight.  May be ' \
                          'null if there are no preceding highlights in this source.'
      end
      property :next_highlight_id do
        key :type, :string
        key :format, 'uuid'
        key :description, 'The ID of the highlight immediately after this highlight.  May be ' \
                          'null if there are no following highlights in this source.'
      end
      property :color do
        key :type, :string
        key :enum, VALID_HIGHLIGHT_COLORS
        key :description, 'The name of the highlight color.  Corresponding RGB values for ' \
                          'different states (e.g. focused, passive) are maintained in the ' \
                          'client.'
      end
      property :anchor do
        key :type, :string
        key :description, 'The anchor of the highlight.'
      end
      property :highlighted_content do
        key :type, :string
        key :description, 'The highlighted content.'
      end
      property :annotation do
        key :type, :string
        key :description, 'The note attached to the highlight.'
      end
      property :location_strategies do
        key :type, :array
        key :description, "Location strategies for the highlight. Items should have a schema " \
                          "matching the strategy schemas that have been defined. (" \
                          "`XpathRangeSelector` or `TextPositionSelector`)."
        items do
          key :type, :object
        end
      end
    end

    add_properties(:Highlight) do
      property :order_in_source do
        key :type, :number
        key :readOnly, true
        key :description, 'A number whose relative value gives the highlight\'s order within the ' \
                          'source. Its value has no meaning on its own.'
      end
    end

    swagger_schema :HighlightUpdate do
      property :color do
        key :type, :string
        key :enum, VALID_HIGHLIGHT_COLORS
        key :description, 'The new name of the highlight color.  Corresponding RGB values for ' \
                          'different states (e.g. focused, passive) are maintained in the ' \
                          'client.'
      end
      property :annotation do
        key :type, :string
        key :description, 'The new note for the highlight (replaces existing note).'
      end
    end

    swagger_path '/highlights' do
      operation :post do
        key :summary, 'Add a highlight'
        key :description, 'Add a highlight with an optional note'
        key :operationId, 'addHighlight'
        key :produces, [
          'application/json'
        ]
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :highlight
          key :in, :body
          key :description, 'The highlight data'
          key :required, true
          schema do
            key :'$ref', :NewHighlight
          end
        end
        response 201 do
          key :description, 'Created.  Returns the created highlight.'
          schema do
            key :'$ref', :Highlight
          end
        end
        extend Api::V0::SwaggerResponses::AuthenticationError
        extend Api::V0::SwaggerResponses::UnprocessableEntityError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end

    swagger_path_and_parameters_schema '/highlights' do
      operation :get do
        key :summary, 'Get filtered highlights'
        key :description, <<~DESC
          Get filtered highlights belonging to the calling user.

          Highlights can be filtered thru query parameters:  source_type, scope_id, source_ids, \
          and color.

          Results are paginated and ordered.  When source_ids are specified, the order is order \
          within the sources.  When source_ids are not specified, the order is by creation time.

          Example call:
            /api/v0/highlights?source_type=openstax_page&scope_id=123&color=#{VALID_HIGHLIGHT_COLORS.first}
        DESC
        key :operationId, 'getHighlights'
        key :produces, [
          'application/json'
        ]
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :source_type
          key :in, :query
          key :type, :string
          key :required, true
          key :enum, ['openstax_page']
          key :description, 'Limits results to those highlights made in sources of this type.'
        end
        parameter do
          key :name, :scope_id
          key :in, :query
          key :type, :string
          key :required, false
          key :description, 'Limits results to the source document container in which the highlight ' \
                            'was made.  For openstax_page source_types, this is a versionless book UUID. ' \
                            'If this is not specified, results across scopes will be returned, meaning ' \
                            'the order of the results will not be meaningful.'
        end
        parameter do
          key :name, :sets
          key :in, :query
          key :type, :array
          key :collectionFormat, :csv
          key :required, false
          key :description, 'One or more sets to load data from; default is "user:me"'
          items do
            key :type, :string
            key :enum, VALID_SETS
          end
        end
        parameter do
          key :name, :source_ids
          key :in, :query
          key :type, :array
          key :collectionFormat, :csv
          key :required, false
          key :description, 'One or more source IDs; query results will contain highlights ordered '\
                            'by the order of these source IDs and ordered within each source.  If ' \
                            'parameter is an empty array, no results will be returned.  If the ' \
                            'parameter is not provided, all highlights under the scope will be ' \
                            'returned.'
          items do
            key :type, :string
          end
        end
        parameter do
          key :name, :colors
          key :in, :query
          key :type, :array
          key :collectionFormat, :csv
          key :required, false
          key :description, 'Limits results to these highlight colors.'
          items do
            key :type, :string
            key :enum, VALID_HIGHLIGHT_COLORS
          end
        end
        parameter do
          key :name, :page
          key :in, :query
          key :type, :integer
          key :required, false
          key :description, 'The page number of paginated results, one-indexed.'
          key :minimum, 1
          key :default, DEFAULT_HIGHLIGHTS_PAGE
        end
        parameter do
          key :name, :per_page
          key :in, :query
          key :type, :integer
          key :required, false
          key :description, 'The number of highlights per page for paginated results.'
          key :minimum, 0
          key :maximum, MAX_HIGHLIGHTS_PER_PAGE
          key :default, DEFAULT_HIGHLIGHTS_PER_PAGE
        end
        response 200 do
          key :description, 'Success.  Returns the filtered highlights.'
          schema do
            key :'$ref', :Highlights
          end
        end
        extend Api::V0::SwaggerResponses::AuthenticationError
        extend Api::V0::SwaggerResponses::UnprocessableEntityError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end

    swagger_path_and_parameters_schema '/highlights/summary' do
      operation :get do
        key :summary, 'Get summary of highlights (counts per source, etc)'
        key :description, <<~DESC
          Get summary of highlights (counts per source, etc) belonging to the calling user.

          Highlights can be filtered thru query parameters:  source_type, scope_id, and color.

          Results are not paginated.

          Example call:
            /api/v0/highlights/summary?source_type=openstax_page&scope_id=123&color=#ff0000
        DESC
        key :operationId, 'getHighlightsSummary'
        key :produces, [
          'application/json'
        ]
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :source_type
          key :in, :query
          key :type, :string
          key :required, true
          key :enum, ['openstax_page']
          key :description, 'Limits summary to those highlights made in sources of this type.'
        end
        parameter do
          key :name, :scope_id
          key :in, :query
          key :type, :string
          key :required, false
          key :description, 'Limits summary to the source document container in which the highlights ' \
                            'were made.  For openstax_page source_types, this is a versionless book UUID.'
        end
        parameter do
          key :name, :sets
          key :in, :query
          key :type, :array
          key :collectionFormat, :csv
          key :required, false
          key :description, 'One or more sets to load data from; default is "user:me"'
          items do
            key :type, :string
            key :enum, VALID_SETS
          end
        end
        parameter do
          key :name, :colors
          key :in, :query
          key :type, :array
          key :collectionFormat, :csv
          key :required, false
          key :description, 'Limits results to these highlight colors.'
          items do
            key :type, :string
            key :enum, VALID_HIGHLIGHT_COLORS
          end
        end
        response 200 do
          key :description, 'Success.  Returns the summary.'
          schema do
            key :'$ref', :HighlightsSummary
          end
        end
        extend Api::V0::SwaggerResponses::AuthenticationError
        extend Api::V0::SwaggerResponses::UnprocessableEntityError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end

    swagger_path '/highlights/{id}' do
      operation :get do
        key :summary, 'Get a highlight without its annotation data.'
        key :description, 'Get a highlight without its annotation data.'
        key :operationId, 'getHighlight'
        key :produces, [
          'application/json'
        ]
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :id
          key :in, :path
          key :description, 'ID of the highlight to find.'
          key :required, true
          key :type, :string
          key :format, 'uuid'
        end
        response 200 do
          key :description, 'Success. Returns the queried highlight.'
          schema do
            key :'$ref', :Highlight
          end
        end
        extend Api::V0::SwaggerResponses::UnprocessableEntityError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end

    swagger_path '/highlights/{id}' do
      operation :put do
        key :summary, 'Update a highlight'
        key :description, 'Update a highlight'
        key :operationId, 'updateHighlight'
        key :produces, [
          'application/json'
        ]
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :id
          key :in, :path
          key :description, 'ID of the highlight to update.'
          key :required, true
          key :type, :string
          key :format, 'uuid'
        end
        parameter do
          key :name, :highlight
          key :in, :body
          key :description, 'The highlight updates.'
          key :required, true
          schema do
            key :'$ref', :HighlightUpdate
          end
        end
        response 200 do
          key :description, 'Success.  Returns the updated highlight.'
          schema do
            key :'$ref', :Highlight
          end
        end
        extend Api::V0::SwaggerResponses::AuthenticationError
        extend Api::V0::SwaggerResponses::UnprocessableEntityError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end

    swagger_path '/highlights/{id}' do
      operation :delete do
        key :summary, 'Delete a highlight'
        key :description, 'Delete a highlight. Can only be done by the owner of the highlight.'
        key :operationId, 'deleteHighlight'
        key :tags, [
          'Highlights'
        ]
        parameter do
          key :name, :id
          key :in, :path
          key :description, 'ID of the highlight to delete'
          key :required, true
          key :type, :string
          key :format, 'uuid'
        end
        response 200 do
          key :description, 'Deleted.'
        end
        extend Api::V0::SwaggerResponses::AuthenticationError
        extend Api::V0::SwaggerResponses::ForbiddenError
        extend Api::V0::SwaggerResponses::NotFoundError
        extend Api::V0::SwaggerResponses::ServerError
      end
    end
  end
end
