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
    relation = VocabTerm.visible_for(options).joins(publication: :publication_group)

    distinct = false
    # By default, only return the latest exercises visible to the user.
    # If either versions, uids or a publication date are specified,
    # this "latest_visible" condition is disabled.
    latest_visible = true

    run(:search, relation: relation,
                 sortable_fields: SORTABLE_FIELDS,
                 params: params) do |with|

      # Block to be used for searches by name or term
      name_search_block = lambda do |names|
        names.each do |nm|
          sanitized_names = to_string_array(nm, append_wildcard: true, prepend_wildcard: true)
          next @items = @items.none if sanitized_names.empty?

          @items = @items.where { name.like_any sanitized_names }
        end
      end

      with.default_keyword :content

      with.keyword :id do |ids|
        ids.each do |id|
          sanitized_ids = to_number_array(id)
          next @items = @items.none if sanitized_ids.empty?

          latest_visible = false
          @items = @items.where(id: sanitized_ids)
        end
      end

      with.keyword :uid do |uids|
        uids.each do |uid|
          sanitized_uids = to_string_array(uid).map { |uid| uid.split('@') }
          next @items = @items.none if sanitized_uids.empty?

          sanitized_numbers = sanitized_uids.map(&:first).compact
          sanitized_versions = sanitized_uids.map(&:second).compact

          # Disable "latest_visible" if any version is specified
          latest_visible = false unless sanitized_versions.empty?

          if sanitized_numbers.empty?
            @items = @items.where(publications: { version: sanitized_versions })
          elsif sanitized_versions.empty?
            @items = @items.where(publication_groups: { number: sanitized_numbers })
          else
            # Combine the id's one at a time using Squeel
            @items = @items.where do
              only_numbers = sanitized_uids.select { |suid| suid.second.blank? }.map(&:first)
              only_versions = sanitized_uids.select { |suid| suid.first.blank? }.map(&:second)
              full_uids = sanitized_uids.reject { |suid| suid.first.blank? || suid.second.blank? }

              cumulative_query = publication.publication_group.number.in(only_numbers) |
                                 publication.version.in(only_versions)

              full_uids.each do |full_uid|
                sanitized_number = full_uid.first
                sanitized_version = full_uid.second
                query = (publication.publication_group.number == sanitized_number) &
                        (publication.version == sanitized_version)
                cumulative_query = cumulative_query | query
              end

              cumulative_query
            end
          end
        end
      end

      with.keyword :uuid do |uuids|
        uuids.each do |uuid|
          sanitized_uuids = to_string_array(uuid)
          next @items = @items.none if sanitized_uuids.empty?

          @items = @items.where(publications: { uuid: sanitized_uuids })
        end

        # Since we are returning specific uuids, disable "latest_visible"
        latest_visible = false
      end

      with.keyword :group_uuid do |uuids|
        uuids.each do |uuid|
          sanitized_uuids = to_string_array(uuid)
          next @items = @items.none if sanitized_uuids.empty?

          @items = @items.where(publication_groups: { uuid: sanitized_uuids })
        end
      end

      with.keyword :number do |numbers|
        numbers.each do |number|
          sanitized_numbers = to_string_array(number)
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

      with.keyword :nickname do |nicknames|
        nicknames.each do |nickname|
          sanitized_nicknames = to_string_array(nickname)
          next @items = @items.none if sanitized_nicknames.empty?

          @items = @items.where(publication_groups: { nickname: sanitized_nicknames })
        end
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
        definitions.each do |df|
          sanitized_definitions = to_string_array(df, append_wildcard: true, prepend_wildcard: true)
          next @items = @items.none if sanitized_definitions.empty?

          @items = @items.where { definition.like_any sanitized_definitions }
        end
      end

      with.keyword :content do |contents|
        contents.each do |content|
          sanitized_contents = to_string_array(content, append_wildcard: true,
                                                        prepend_wildcard: true)
          next @items = @items.none if sanitized_contents.empty?

          @items = @items.where do
            name.like_any(sanitized_contents) | definition.like_any(sanitized_contents)
          end
        end
      end

      with.keyword :author do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins(publication: { authors: { user: :account } }).where do
            publication.authors.user.account.username.like_any(sn) |
            publication.authors.user.account.first_name.like_any(sn) |
            publication.authors.user.account.last_name.like_any(sn) |
            publication.authors.user.account.full_name.like_any(sn)
          end
        end
      end

      with.keyword :copyright_holder do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins(publication: { copyright_holders: { user: :account } }).where do
            publication.copyright_holders.user.account.username.like_any(sn) |
            publication.copyright_holders.user.account.first_name.like_any(sn) |
            publication.copyright_holders.user.account.last_name.like_any(sn) |
            publication.copyright_holders.user.account.full_name.like_any(sn)
          end
        end
      end

      with.keyword :collaborator do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          distinct = true
          @items = @items.joins {publication.authors.outer.user.outer.account.outer}
                         .joins {publication.copyright_holders.outer.user.outer.account.outer}
                         .where do
            publication.authors.user.account.username.like_any(sn) |
            publication.authors.user.account.first_name.like_any(sn) |
            publication.authors.user.account.last_name.like_any(sn) |
            publication.authors.user.account.full_name.like_any(sn) |
            publication.copyright_holders.user.account.username.like_any(sn) |
            publication.copyright_holders.user.account.first_name.like_any(sn) |
            publication.copyright_holders.user.account.last_name.like_any(sn) |
            publication.copyright_holders.user.account.full_name.like_any(sn)
          end
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
