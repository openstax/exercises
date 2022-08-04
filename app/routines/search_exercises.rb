class SearchExercises

  MAX_PER_PAGE = 100

  lev_routine express_output: :items

  uses_routine OSU::SearchAndOrganizeRelation,
               as: :search,
               translations: { outputs: { type: :verbatim } }

  SORTABLE_FIELDS = {
    'number' => '"publication_group"."number"',
    'uuid' => '"publication_group"."uuid"',
    'version' => '"publication"."version"',
    'title' => :title,
    'created_at' => :created_at,
    'updated_at' => :updated_at,
    'published_at' => '"publication"."published_at"'
  }

  protected

  def exec(params = {}, options = {})
    params[:ob] ||= [{number: :asc}, {version: :desc}]
    params[:per_page] = [
      Integer(params[:per_page] || params[:pp]), MAX_PER_PAGE
    ].min rescue MAX_PER_PAGE
    relation = Exercise.visible_for(options).joins(publication: :publication_group)

    # Rails 6.1 workaround to force consistent table aliases
    relation = relation.where.not(publication: { id: nil }, publication_group: { id: nil })

    # By default, only return the latest exercises visible to the user.
    # If either versions, ids, uids or a publication date are specified,
    # this "latest_visible" condition is disabled.
    latest_visible = true

    ex = Exercise.arel_table
    qu = Question.arel_table
    st = Stem.arel_table
    ans = Answer.arel_table
    pub = Publication.arel_table
    pubg = PublicationGroup.arel_table
    acct = OpenStax::Accounts::Account.arel_table

    # NB: this encapsulates magic knowledge of how ActiveRecord will alias second join of accounts
    acct_author = OpenStax::Accounts::Account.arel_table
    acct_copyright = OpenStax::Accounts::Account.arel_table.alias('accounts_users')

    run(:search, relation: relation, sortable_fields: SORTABLE_FIELDS, params: params) do |with|
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
            @items = @items.where(publication: { version: sanitized_versions })
          elsif sanitized_versions.empty?
            @items = @items.where(publication_group: { number: sanitized_numbers })
          else
            only_numbers = sanitized_uids.select { |suid| suid.second.blank? }.map(&:first)
            only_versions = sanitized_uids.select { |suid| suid.first.blank? }.map(&:second)
            full_uids = sanitized_uids.reject { |suid| suid.first.blank? || suid.second.blank? }

            rel = @items.where(publication_group: { number: only_numbers }).or(
              @items.where(publication: { version: only_versions })
            )

            full_uids.each do |full_uid|
              sanitized_number = full_uid.first
              sanitized_version = full_uid.second

              rel = rel.or(
                @items.where(
                  publication_group: { number: sanitized_number },
                  publication: { version: sanitized_version })
              )
            end

            @items = rel
          end
        end
      end

      with.keyword :uuid do |uuids|
        uuids.each do |uuid|
          sanitized_uuids = to_string_array(uuid)
          next @items = @items.none if sanitized_uuids.empty?

          @items = @items.where(publication: { uuid: sanitized_uuids })
        end

        # Since we are returning specific uuids, disable "latest_visible"
        latest_visible = false
      end

      with.keyword :group_uuid do |uuids|
        uuids.each do |uuid|
          sanitized_uuids = to_string_array(uuid)
          next @items = @items.none if sanitized_uuids.empty?

          @items = @items.where(publication_group: { uuid: sanitized_uuids })
        end
      end

      with.keyword :number do |numbers|
        numbers.each do |number|
          sanitized_numbers = to_string_array(number)
          next @items = @items.none if sanitized_numbers.empty?

          @items = @items.where(publication_group: { number: sanitized_numbers })
        end
      end

      with.keyword :version do |versions|
        versions.each do |version|
          sanitized_versions = to_string_array(version)
          next @items = @items.none if sanitized_versions.empty?

          @items = @items.where(publication: { version: sanitized_versions })
        end

        # Since we are returning specific versions, disable "latest_visible"
        latest_visible = false
      end

      with.keyword :nickname do |nicknames|
        nicknames.each do |nickname|
          sanitized_nicknames = to_string_array(nickname)
          next @items = @items.none if sanitized_nicknames.empty?

          @items = @items.where(publication_group: { nickname: sanitized_nicknames })
        end
      end

      with.keyword :tag do |tags|
        tags.each do |tag|
          sanitized_tags = to_string_array(tag).map(&:downcase)
          next @items = @items.none if sanitized_tags.empty?

          @items = @items.where(
            ExerciseTag.joins(:tag).where(
              '"exercise_tags"."exercise_id" = "exercises"."id"'
            ).where(tag: { name: sanitized_tags }).arel.exists
          )
        end
      end

      with.keyword :title do |titles|
        titles.each do |ttl|
          sanitized_titles = to_string_array(ttl, append_wildcard: true, prepend_wildcard: true)
          next @items = @items.none if sanitized_titles.empty?

          @items = @items.where(ex[:title].matches_any(sanitized_titles))
        end
      end

      with.keyword :content do |contents|
        contents.each do |content|
          sanitized_contents = to_string_array(content, append_wildcard: true,
                                                        prepend_wildcard: true)
          next @items = @items.none if sanitized_contents.empty?

          @items = @items.left_joins(questions: [:stems, :answers]).where(
               ex[:title].matches_any(sanitized_contents)
           .or(ex[:stimulus].matches_any(sanitized_contents))
           .or(qu[:stimulus].matches_any(sanitized_contents))
           .or(st[:content].matches_any(sanitized_contents))
           .or(ans[:content].matches_any(sanitized_contents)))
        end
      end

      with.keyword :author do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins(:publication).where(
            Author.joins(user: :account).where(
              '"authors"."publication_id" = "publication"."id"'
            ).where(
              acct[:username].matches_any(sn)
                .or(acct[:first_name].matches_any(sn))
                .or(acct[:last_name].matches_any(sn))
                .or(acct[:full_name].matches_any(sn))
            ).arel.exists
          )
        end
      end

      with.keyword :copyright_holder do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins(:publication).where(
            CopyrightHolder.joins(user: :account).where(
              '"copyright_holders"."publication_id" = "publication"."id"'
            ).where(
              acct[:username].matches_any(sn)
                .or(acct[:first_name].matches_any(sn))
                .or(acct[:last_name].matches_any(sn))
                .or(acct[:full_name].matches_any(sn))
            ).arel.exists
          )
        end
      end

      with.keyword :collaborator do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins(:publication).where(
            Author.joins(user: :account).where(
              '"authors"."publication_id" = "publication"."id"'
            ).where(
              acct[:username].matches_any(sn)
                .or(acct[:first_name].matches_any(sn))
                .or(acct[:last_name].matches_any(sn))
                .or(acct[:full_name].matches_any(sn))
            ).arel.exists.or(
              CopyrightHolder.joins(user: :account).where(
                '"copyright_holders"."publication_id" = "publication"."id"'
              ).where(
                acct[:username].matches_any(sn)
                  .or(acct[:first_name].matches_any(sn))
                  .or(acct[:last_name].matches_any(sn))
                  .or(acct[:full_name].matches_any(sn))
              ).arel.exists
            )
          )
        end
      end

      with.keyword :format do |formats|
        formats.each do |format|
          sanitized_formats = to_string_array(format).map(&:downcase)
          next @items = @items.none if sanitized_formats.empty?

          @items = @items.where(
            Question.joins(stems: :stylings).where(
              '"questions"."exercise_id" = "exercises"."id"'
            ).where(stems: { stylings: { style: sanitized_formats } }).arel.exists
          )
        end
      end

      with.keyword :solutions_are_public do |saps|
        saps.each do |sap|
          sanitized_saps = to_string_array(sap).map do |str|
            ActiveModel::Type::Boolean.new.cast(str)
          end
          next @items = @items.none if sanitized_saps.empty?

          @items = @items.joins(publication: :publication_group).where(
            publication: { publication_group: { solutions_are_public: sanitized_saps } }
          )
        end
      end
    end

    outputs.items = outputs.items.select(
      [
        ex[ Arel.star ],
        '"publication_group"."uuid"',
        '"publication_group"."number"',
        '"publication"."version"',
        '"publication"."published_at"'
      ]
    ).distinct

    return unless latest_visible

    outputs.items = outputs.items.chainable_latest
    outputs.total_count = outputs.items.limit(nil).offset(nil).reorder(nil).count(:all)
  end
end
