class SearchExercises < OSU::AbstractKeywordSearchRoutine
  self.search_proc = lambda { |with|
    with.default_keyword :content

    with.keyword :id, :uid do |ids|
      ids.each do |id|
        sanitized_ids = to_string_array(id).collect{|id| id.split('v')}
        next @items = @items.none if sanitized_ids.empty?
        sanitized_numbers = sanitized_ids.collect{|sid| sid.first}.compact
                                         .collect{|snum| snum.gsub(/\Ae/, '')}
        sanitized_versions = sanitized_ids.collect{|sid| sid.second}.compact
        if sanitized_numbers.empty?
          @items = @items.where{publication.version.like_any sanitized_versions}
        elsif sanitized_versions.empty?
          @items = @items.where{publication.number.like_any sanitized_numbers}
        else
          @items = @items.where{(publication.number.like_any sanitized_numbers) &\
                                (publication.version.like_any sanitized_versions)}
        end
      end
    end

    with.keyword :number do |numbers|
      numbers.each do |number|
        sanitized_numbers = to_string_array(numbers)
        next @items = @items.none if sanitized_numbers.empty?
        @items = @items.where{publication.number.like_any sanitized_numbers}
      end
    end

    with.keyword :version do |versions|
      versions.each do |version|
        sanitized_versions = to_string_array(version)
        next @items = @items.none if sanitized_versions.empty?
        @items = @items.where{publication.version.like_any sanitized_versions}
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
        @items = @items.includes(parts: {questions: [:items, :answers]})
                       .references(parts: {questions: [:items, :answers]})
                       .where{(title.like_any sanitized_contents) |\
                              (background.like_any sanitized_contents) |\
                              (parts.background.like_any sanitized_contents) |\
                              (questions.stem.like_any sanitized_contents) |\
                              (items.content.like_any sanitized_contents) |\
                              (answers.content.like_any sanitized_contents)}
      end
    end

    with.keyword :solution do |solutions|
      solutions.each do |solution|
        sanitized_solutions = to_string_array(solution, append_wildcard: true,
                                                         prepend_wildcard: true)
        next @items = @items.none if sanitized_solutions.empty?
        @items = @items.includes(:solutions).joins(:solutions)
                       .where{(solutions.summary.like_any sanitized_solutions) |\
                              (solutions.details.like_any sanitized_solutions)}
      end
    end

    with.keyword :author do |names|
      names.each do |name|
        sn = to_string_array(name, append_wildcard: true)
        next @items = @items.none if sn.empty?
        @items = @items.includes(authors: {user: :account})
                       .joins(authors: {user: :account})
                       .where{(authors.user.account.username.like_any sn) |\
                              (authors.user.account.first_name.like_any sn) |\
                              (authors.user.account.last_name.like_any sn) |\
                              (authors.user.account.full_name.like_any sn)}
      end
    end

    with.keyword :copyright_holder do |names|
      names.each do |name|
        sn = to_string_array(name, append_wildcard: true)
        next @items = @items.none if sn.empty?
        @items = @items.includes(copyright_holders: {user: :account})
                       .joins(copyright_holders: {user: :account})
                       .where{(copyright_holders.user.account.username.like_any sn) |\
                              (copyright_holders.user.account.first_name.like_any sn) |\
                              (copyright_holders.user.account.last_name.like_any sn) |\
                              (copyright_holders.user.account.full_name.like_any sn)}
      end
    end

    with.keyword :editor do |names|
      names.each do |name|
        sn = to_string_array(name, append_wildcard: true)
        next @items = @items.none if sn.empty?
        @items = @items.includes(editors: {user: :account})
                       .joins(editors: {user: :account})
                       .where{(editors.user.account.username.like_any sn) |\
                              (editors.user.account.first_name.like_any sn) |\
                              (editors.user.account.last_name.like_any sn) |\
                              (editors.user.account.full_name.like_any sn)}
      end
    end

    with.keyword :collaborator do |names|
      names.each do |name|
        sn = to_string_array(name, append_wildcard: true)
        next @items = @items.none if sn.empty?
        @items = @items.includes(authors: {user: :account},
                                 copyright_holders: {user: :account},
                                 editors: {user: :account})
                       .where{(authors.user.account.username.like_any sn) |\
                              (authors.user.account.first_name.like_any sn) |\
                              (authors.user.account.last_name.like_any sn) |\
                              (authors.user.account.full_name.like_any sn) |\
                              (copyright_holders.user.account.username.like_any sn) |\
                              (copyright_holders.user.account.first_name.like_any sn) |\
                              (copyright_holders.user.account.last_name.like_any sn) |\
                              (copyright_holders.user.account.full_name.like_any sn) |\
                              (editors.user.account.username.like_any sn) |\
                              (editors.user.account.first_name.like_any sn) |\
                              (editors.user.account.last_name.like_any sn) |\
                              (editors.user.account.full_name.like_any sn)}
      end
    end
  }

  self.sortable_fields_map = {
    'title' => :title,
    'number' => Publication.arel_table[:number],
    'version' => Publication.arel_table[:version],
    'created_at' => :created_at
  }
end
