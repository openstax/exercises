class SearchVocabTerms

  lev_routine express_output: :items

  uses_routine OSU::SearchAndOrganizeRelation,
               as: :search,
               translations: { outputs: { type: :verbatim } }

  SORTABLE_FIELDS = {
    'number' => PublicationGroup.arel_table[:number],
    'uuid' => PublicationGroup.arel_table[:uuid],
    'version' => Publication.arel_table[:version],
    'name' => :name,
    'definition' => :definition,
    'created_at' => :created_at,
    'updated_at' => :updated_at,
    'published_at' => Publication.arel_table[:published_at]
  }

  protected

  def exec(params = {}, options = {})
    params[:ob] ||= [{number: :asc}, {version: :desc}]
    relation = VocabTerm.visible_for(options[:user]).joins(publication: :publication_group)

    distinct = false
    # By default, only return the latest exercises visible to the user.
    # If either versions, uids or a publication date are specified,
    # this "latest_visible" condition is disabled.
    latest_visible = true

    run(:search, relation: relation,
                 sortable_fields: SORTABLE_FIELDS,
                 params: params) do |with|

      # Block to be used for searches by id or uid
      id_search_block = lambda do |ids|
        ids.each do |id|
          sanitized_ids = to_string_array(id).map { |id| id.split('@') }
          next @items = @items.none if sanitized_ids.empty?

          sanitized_numbers = sanitized_ids.map(&:first).compact
          sanitized_versions = sanitized_ids.map(&:second).compact
          if sanitized_numbers.empty?
            @items = @items.where(publications: { version: sanitized_versions })
          elsif sanitized_versions.empty?
            @items = @items.where do
              publication.uuid.in(sanitized_numbers) |
              publication.publication_group.number.in(sanitized_numbers) |
              publication.publication_group.uuid.in(sanitized_numbers)
            end
          else
            # Combine the id's one at a time using Squeel
            @items = @items.where do
              only_numbers = sanitized_ids.select { |sid| sid.second.blank? }.map(&:first)
              only_versions = sanitized_ids.select { |sid| sid.first.blank? }.map(&:second)
              full_ids = sanitized_ids.reject { |sid| sid.first.blank? || sid.second.blank? }

              cumulative_query = publication.uuid.in(only_numbers) |
                                 publication.publication_group.number.in(only_numbers) | \
                                 publication.publication_group.uuid.in(only_numbers) | \
                                 publication.version.in(only_versions)

              full_ids.each do |full_id|
                sanitized_number = full_id.first
                sanitized_version = full_id.second
                query = ((publication.publication_group.uuid == sanitized_number) |
                         (publication.publication_group.number == sanitized_number)) & \
                        (publication.version == sanitized_version)
                cumulative_query = cumulative_query | query
              end

              cumulative_query
            end
          end
        end

        # Since we are returning specific uids, disable "latest_visible"
        latest_visible = false
      end

      # Block to be used for searches by name or term
      name_search_block = lambda do |names|
        names.each do |name|
          sanitized_names = to_string_array(name, append_wildcard: true, prepend_wildcard: true)
          next @items = @items.none if sanitized_names.empty?

          @items = @items.where {name.like_any sanitized_names}
        end
      end

      with.default_keyword :content

      with.keyword :id, &id_search_block

      with.keyword :uid, &id_search_block

      with.keyword :uuid do |uuids|
        uuids.each do |uuid|
          sanitized_uuids = to_string_array(uuids)
          next @items = @items.none if sanitized_uuids.empty?

          @items = @items.where do
            publication.uuid.in(sanitized_uuids) |
            publication.publication_group.uuid.in(sanitized_uuids)
          end
        end
      end

      with.keyword :number do |numbers|
        numbers.each do |number|
          sanitized_numbers = to_string_array(numbers)
          next @items = @items.none if sanitized_numbers.empty?

          @items = @items.where(publication_groups: { number: sanitized_numbers })
        end
      end

      with.keyword :version do |versions|
        versions.each do |version|
          sanitized_versions = to_string_array(version)
          next @items = @items.none if sanitized_versions.empty?

          @items = @items.where(publications: { version: sanitized_versions })
        end

        # Since we are returning specific versions, disable "latest_visible"
        latest_visible = false
      end

      with.keyword :tag do |tags|
        tags.each do |tag|
          sanitized_tags = to_string_array(tag).map(&:downcase)
          next @items = @items.none if sanitized_tags.empty?

          distinct = true
          @items = @items.joins(:tags).where(tags: { name: sanitized_tags })
        end
      end

      with.keyword :name, &name_search_block

      with.keyword :term, &name_search_block

      with.keyword :definition do |definitions|
        definitions.each do |definition|
          sanitized_definitions = to_string_array(definition, append_wildcard: true,
                                                              prepend_wildcard: true)
          next @items = @items.none if sanitized_definitions.empty?

          @items = @items.where {definition.like_any sanitized_definitions}
        end
      end

      with.keyword :content do |contents|
        contents.each do |content|
          sanitized_contents = to_string_array(content, append_wildcard: true,
                                                        prepend_wildcard: true)
          next @items = @items.none if sanitized_contents.empty?

          @items = @items.where { (name.like_any sanitized_contents) |\
                                 (definition.like_any sanitized_contents) }
        end
      end

      with.keyword :author do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins(publication: {authors: {user: :account}})
                         .where {
                           (publication.authors.user.account.username.like_any sn) |\
                           (publication.authors.user.account.first_name.like_any sn) |\
                           (publication.authors.user.account.last_name.like_any sn) |\
                           (publication.authors.user.account.full_name.like_any sn)
                         }
        end
      end

      with.keyword :copyright_holder do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins(publication: {copyright_holders: {user: :account}})
                         .where {
                           (publication.copyright_holders.user.account.username.like_any sn) |\
                           (publication.copyright_holders.user.account.first_name.like_any sn) |\
                           (publication.copyright_holders.user.account.last_name.like_any sn) |\
                           (publication.copyright_holders.user.account.full_name.like_any sn)
                         }
        end
      end

      with.keyword :collaborator do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins {publication.authors.outer.user.outer.account.outer}
                         .joins {publication.copyright_holders.outer.user.outer.account.outer}
                         .where {
                           (publication.authors.user.account.username.like_any sn) |\
                           (publication.authors.user.account.first_name.like_any sn) |\
                           (publication.authors.user.account.last_name.like_any sn) |\
                           (publication.authors.user.account.full_name.like_any sn) |\
                           (publication.copyright_holders.user.account.username.like_any sn) |\
                           (publication.copyright_holders.user.account.first_name.like_any sn) |\
                           (publication.copyright_holders.user.account.last_name.like_any sn) |\
                           (publication.copyright_holders.user.account.full_name.like_any sn)
                         }
        end
      end

    end

    if distinct
      pg = PublicationGroup.arel_table
      pb = Publication.arel_table

      outputs[:items] = outputs[:items].select(
        [
          VocabTerm.arel_table[ Arel.star ],
          pg[:uuid],
          pg[:number],
          pb[:version],
          pb[:published_at]
        ]
      ).distinct
    end

    return unless latest_visible

    outputs[:items] = outputs[:items].chainable_latest
    outputs[:total_count] = outputs[:items].limit(nil).offset(nil).reorder(nil).count
  end
end
