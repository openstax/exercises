class SearchExercises

  lev_routine

  uses_routine OSU::SearchAndOrganizeRelation,
               as: :search,
               translations: { outputs: { type: :verbatim } }

  SORTABLE_FIELDS = {
    'number' => Publication.arel_table[:number],
    'version' => Publication.arel_table[:version],
    'title' => :title,
    'created_at' => :created_at
  }

  protected

  def exec(params = {}, options = {})
    params[:ob] ||= [{number: :asc}, {version: :desc}]

    latest_only = true
    run(:search, relation: Exercise.visible_for(options[:user]).preloaded,
                 sortable_fields: SORTABLE_FIELDS,
                 params: params) do |with|
      with.default_keyword :content

      with.keyword :id, :uid do |ids|
        latest_only = false

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
            @items = @items.where(publication: {number: sanitized_numbers,
                                                version: sanitized_versions})
          end
        end
      end

      with.keyword :number do |numbers|
        numbers.each do |number|
          sanitized_numbers = to_string_array(numbers)
          next @items = @items.none if sanitized_numbers.empty?
          @items = @items.where(publication: {number: sanitized_versions})
        end
      end

      with.keyword :version do |versions|
        latest_only = false

        versions.each do |version|
          sanitized_versions = to_string_array(version)
          next @items = @items.none if sanitized_versions.empty?
          @items = @items.where(publication: {version: sanitized_versions})
        end
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
          @items = @items.joins{publication.outer.authors.outer.user.outer.account.outer}
                         .joins{publication.outer.copyright_holders.outer.user.outer.account.outer}
                         .joins{publication.outer.editors.outer.user.outer.account.outer}
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
    end

    return unless latest_only
    outputs[:items] = outputs[:items].latest
    outputs[:total_count] = outputs[:items].limit(nil).offset(nil).reorder(nil).count
  end
end
