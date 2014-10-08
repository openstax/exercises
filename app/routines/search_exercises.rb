class SearchExercises < OSU::AbstractKeywordSearchRoutine
  self.initial_relation = Exercise.unscoped.includes(:publication).joins(:publication)

  self.search_proc = lambda { |with|
    with.default_keyword :content

    with.keyword :id, :uid do |ids|
      sanitized_ids = to_string_array(ids).collect{|id| id.split('v')}
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

    with.keyword :number do |numbers|
      sanitized_numbers = to_string_array(numbers)
      @items = @items.where{publication.number.like_any sanitized_numbers}
    end

    with.keyword :version do |versions|
      sanitized_versions = to_string_array(versions)
      @items = @items.where{publication.version.like_any sanitized_versions}
    end

    with.keyword :title do |titles|
      sanitized_titles = to_string_array(titles, append_wildcard: true,
                                                 prepend_wildcard: true)
      @items = @items.where{title.like_any sanitized_titles}
    end

    with.keyword :content do |contents|
      sanitized_contents = to_string_array(contents, append_wildcard: true,
                                                     prepend_wildcard: true)
      @items = @items.includes(parts: {questions: [:items, :answers]})
                     .where{(title.like_any sanitized_contents) |\
                            (background.like_any sanitized_contents) |\
                            (parts.background.like_any sanitized_contents) |\
                            (questions.stem.like_any sanitized_contents) |\
                            (items.content.like_any sanitized_contents) |\
                            (answers.content.like_any sanitized_contents)}
    end

    with.keyword :solution do |solutions|
      sanitized_solutions = to_string_array(solutions, append_wildcard: true,
                                                       prepend_wildcard: true)
      @items = @items.includes(:solutions).joins(:solutions)
                     .where{(solutions.summary.like_any sanitized_solutions) |\
                            (solutions.details.like_any sanitized_solutions)}
    end

    with.keyword :author do |names|
      sn = to_string_array(names, append_wildcard: true)
      @items = @items.includes(authors: {user: :account})
                     .joins(authors: {user: :account})
                     .where{(authors.user.account.username.like_any sn) |\
                            (authors.user.account.first_name.like_any sn) |\
                            (authors.user.account.last_name.like_any sn) |\
                            (authors.user.account.full_name.like_any sn) |\
                            (authors.user.account.title.like_any sn)}
    end

    with.keyword :copyright_holder do |names|
      sn = to_string_array(names, append_wildcard: true)
      @items = @items.includes(copyright_holders: {user: :account})
                     .joins(copyright_holders: {user: :account})
                     .where{(copyright_holders.user.account.username.like_any sn) |\
                            (copyright_holders.user.account.first_name.like_any sn) |\
                            (copyright_holders.user.account.last_name.like_any sn) |\
                            (copyright_holders.user.account.full_name.like_any sn) |\
                            (copyright_holders.user.account.title.like_any sn)}
    end

    with.keyword :editor do |names|
      sn = to_string_array(names, append_wildcard: true)
      @items = @items.includes(editors: {user: :account})
                     .joins(editors: {user: :account})
                     .where{(editors.user.account.username.like_any sn) |\
                            (editors.user.account.first_name.like_any sn) |\
                            (editors.user.account.last_name.like_any sn) |\
                            (editors.user.account.full_name.like_any sn) |\
                            (editors.user.account.title.like_any sn)}
    end

    with.keyword :collaborator do |names|
      sn = to_string_array(names, append_wildcard: true)
      @items = @items.includes(authors: {user: :account},
                               copyright_holders: {user: :account},
                               editors: {user: :account})
                     .where{(authors.user.account.username.like_any sn) |\
                            (authors.user.account.first_name.like_any sn) |\
                            (authors.user.account.last_name.like_any sn) |\
                            (authors.user.account.full_name.like_any sn) |\
                            (authors.user.account.title.like_any sn) |\
                            (copyright_holders.user.account.username.like_any sn) |\
                            (copyright_holders.user.account.first_name.like_any sn) |\
                            (copyright_holders.user.account.last_name.like_any sn) |\
                            (copyright_holders.user.account.full_name.like_any sn) |\
                            (copyright_holders.user.account.title.like_any sn) |\
                            (editors.user.account.username.like_any sn) |\
                            (editors.user.account.first_name.like_any sn) |\
                            (editors.user.account.last_name.like_any sn) |\
                            (editors.user.account.full_name.like_any sn) |\
                            (editors.user.account.title.like_any sn)}
    end
  }

  self.sortable_fields_map = {
    'title' => :title,
    'number' => :number,
    'version' => :version,
    'created_at' => :created_at
  }
end
