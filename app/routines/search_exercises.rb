class SearchExercises

  lev_routine express_output: :items

  uses_routine OSU::SearchAndOrganizeRelation,
               as: :search,
               translations: { outputs: { type: :verbatim } }

  SORTABLE_FIELDS = {
    'number' => Publication.arel_table[:number],
    'version' => Publication.arel_table[:version],
    'title' => :title,
    'created_at' => :created_at,
    'updated_at' => :updated_at,
    'published_at' => Publication.arel_table[:published_at]
  }

  protected

  def exec(params = {}, options = {})
    params[:ob] ||= [{number: :asc}, {version: :desc}]
    relation = Exercise.visible_for(options[:user]).joins(:publication)

    # By default, only return the latest exercises visible to the user.
    # If either versions, uids or a publication date are specified,
    # this "latest" condition is disabled.
    latest_scope = relation

    run(:search, relation: relation.preloaded,
                 sortable_fields: SORTABLE_FIELDS,
                 params: params) do |with|

      # Block to be used for searches by id or uid
      id_search_block = lambda do |ids|
        ids.each do |id|
          sanitized_ids = to_string_array(id).collect{|id| id.split('@')}
          next @items = @items.none if sanitized_ids.empty?

          sanitized_numbers = sanitized_ids.collect{|sid| sid.first}.compact
          sanitized_versions = sanitized_ids.collect{|sid| sid.second}.compact
          if sanitized_numbers.empty?
            @items = @items.where(publication: {version: sanitized_versions})
          elsif sanitized_versions.empty?
            @items = @items.where(publication: {number: sanitized_numbers})
          else
            # Combine the id's one at a time using Squeel
            @items = @items.where do
              only_numbers = sanitized_ids.select{ |sid| sid.second.blank? }.collect(&:first)
              only_versions = sanitized_ids.select{ |sid| sid.first.blank? }.collect(&:second)
              full_ids = sanitized_ids.reject{ |sid| sid.first.blank? || sid.second.blank? }

              cumulative_query = publication.number.in(only_numbers) | \
                                 publication.version.in(only_versions)

              full_ids.each do |full_id|
                sanitized_number = full_id.first
                sanitized_version = full_id.second
                query = (publication.number == sanitized_number) & \
                        (publication.version == sanitized_version)
                cumulative_query = cumulative_query | ((publication.number == sanitized_number) & \
                                                       (publication.version == sanitized_version))
              end

              cumulative_query
            end
          end
        end

        # Since we are returning specific uids, disable "latest"
        latest_scope = nil
      end

      with.default_keyword :content

      with.keyword :id, &id_search_block

      with.keyword :uid, &id_search_block

      with.keyword :number do |numbers|
        numbers.each do |number|
          sanitized_numbers = to_string_array(numbers)
          next @items = @items.none if sanitized_numbers.empty?

          @items = @items.where(publication: {number: sanitized_versions})
        end
      end

      with.keyword :version do |versions|
        versions.each do |version|
          sanitized_versions = to_string_array(version)
          next @items = @items.none if sanitized_versions.empty?

          @items = @items.where(publication: {version: sanitized_versions})
        end

        # Since we are returning specific versions, disable "latest"
        latest_scope = nil
      end

      with.keyword :tag do |tags|
        tags.each do |tag|
          sanitized_tags = to_string_array(tag).collect{|t| t.downcase}
          next @items = @items.none if sanitized_tags.empty?

          @items = @items.joins(:tags)
                         .where(tags: {name: sanitized_tags})
        end
      end

      with.keyword :title do |titles|
        titles.each do |title|
          sanitized_titles = to_string_array(title, append_wildcard: true,
                                                    prepend_wildcard: true)
          next @items = @items.none if sanitized_titles.empty?

          @items = @items.where{title.like_any sanitized_titles}
        end
      end

      with.keyword :content do |contents|
        contents.each do |content|
          sanitized_contents = to_string_array(content, append_wildcard: true,
                                                        prepend_wildcard: true)
          next @items = @items.none if sanitized_contents.empty?

          @items = @items.joins{[questions.outer.stems.outer, questions.outer.answers.outer]}
                         .where{
                           (title.like_any sanitized_contents) |\
                           (stimulus.like_any sanitized_contents) |\
                           (questions.stimulus.like_any sanitized_contents) |\
                           (questions.stems.content.like_any sanitized_contents) |\
                           (questions.answers.content.like_any sanitized_contents)
                         }
        end
      end

      with.keyword :solution do |solutions|
        solutions.each do |solution|
          sanitized_solutions = to_string_array(solution, append_wildcard: true,
                                                          prepend_wildcard: true)
          next @items = @items.none if sanitized_solutions.empty?

          @items = @items.joins(:solutions)
                         .where{(solutions.summary.like_any sanitized_solutions) |\
                                (solutions.details.like_any sanitized_solutions)}
        end
      end

      with.keyword :author do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins(publication: {authors: {user: :account}})
                         .where{
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

          @items = @items.joins(publication: {copyright_holders: {user: :account}})
                         .where{
                           (publication.copyright_holders.user.account.username.like_any sn) |\
                           (publication.copyright_holders.user.account.first_name.like_any sn) |\
                           (publication.copyright_holders.user.account.last_name.like_any sn) |\
                           (publication.copyright_holders.user.account.full_name.like_any sn)
                         }
        end
      end

      with.keyword :editor do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins(publication: {editors: {user: :account}})
                         .where{
                           (publication.editors.user.account.username.like_any sn) |\
                           (publication.editors.user.account.first_name.like_any sn) |\
                           (publication.editors.user.account.last_name.like_any sn) |\
                           (publication.editors.user.account.full_name.like_any sn)
                         }
        end
      end

      with.keyword :collaborator do |names|
        names.each do |name|
          sn = to_string_array(name, append_wildcard: true)
          next @items = @items.none if sn.empty?

          @items = @items.joins{publication.authors.outer.user.outer.account.outer}
                         .joins{publication.copyright_holders.outer.user.outer.account.outer}
                         .joins{publication.editors.outer.user.outer.account.outer}
                         .where{
                           (publication.authors.user.account.username.like_any sn) |\
                           (publication.authors.user.account.first_name.like_any sn) |\
                           (publication.authors.user.account.last_name.like_any sn) |\
                           (publication.authors.user.account.full_name.like_any sn) |\
                           (publication.copyright_holders.user.account.username.like_any sn) |\
                           (publication.copyright_holders.user.account.first_name.like_any sn) |\
                           (publication.copyright_holders.user.account.last_name.like_any sn) |\
                           (publication.copyright_holders.user.account.full_name.like_any sn) |\
                           (publication.editors.user.account.username.like_any sn) |\
                           (publication.editors.user.account.first_name.like_any sn) |\
                           (publication.editors.user.account.last_name.like_any sn) |\
                           (publication.editors.user.account.full_name.like_any sn)
                         }
        end
      end

      with.keyword :published_before do |published_befores|
        min_published_before = published_befores.flatten.collect do |str|
          DateTime.parse(str) rescue nil
        end.compact.min
        next @items = @items.none if min_published_before.nil?

        @items = @items.where{ publication.published_at < min_published_before }

        # Latest now refers to results that happened before min_published_before
        latest_scope = latest_scope.where{ publication.published_at < min_published_before } \
          unless latest_scope.nil?
      end

    end

    return if latest_scope.nil?

    outputs[:items] = outputs[:items].latest(latest_scope)
    outputs[:total_count] = outputs[:items].limit(nil).offset(nil).reorder(nil).count
  end
end
