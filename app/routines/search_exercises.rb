class SearchExercises

  lev_routine

  SORTABLE_FIELDS = []

  protected

  def exec(params)
    outputs[:exercises] = Exercise.all
    return

    case type
    when 'published exercises'
      tscope = visible_for(user).published
    when 'draft exercises'
      tscope = visible_for(user).not_published
    when 'exercises in my lists'
      tscope = user.nil? ? none : user.listed_exercises
    else # all exercises
      tscope = visible_for(user)
    end

    case answer_type
    when 'true or false answers'
      ascope = tscope.with_true_or_false_answers
    when 'multiple choice answers'
      ascope = tscope.with_multiple_choice_answers
    when 'matching answers'
      ascope = tscope.with_matching_answers
    when 'fill in the blank answers'
      ascope = tscope.with_fill_in_the_blank_answers
    when 'short answers'
      ascope = tscope.with_short_answers
    when 'free response answers'
      ascope = tscope.with_free_response_answers
    else # any answer types
      ascope = tscope
    end

    latest_only = true
    if text.blank?
      qscope = ascope
    else
      text = text.gsub('%', '')

      case part
      when 'tags'
        # Search by tags
        qscope = ascope.joins{taggings.tag}
        text.split(",").each do |t|
          query = t.blank? ? '%' : '%' + t + '%'
          qscope = qscope.where{tags.name =~ query}
        end
      when 'author/copyright holder'
        # Search by author (or copyright holder)
        qscope = ascope.joins{collaborators.user}
        text.gsub(",", " ").split.each do |t|
          query = t.blank? ? '%' : '%' + t + '%'
          qscope = qscope.where{(collaborators.user.first_name =~ query) |\
                                (collaborators.user.last_name =~ query)}
        end
      when 'ID/number'
        # Search by exercise ID or number
        latest_only = false
        if (text =~ /^\s?(\d+)\s?$/) # Format: (id or number)
          id_query = $1
          num_query = $1
          qscope = ascope.where{(id == id_query) | (number == num_query)}
        elsif (text =~ /^\s?e(\d+)d\s?$/) # Format: e(id)d
          id_query = $1
          qscope = ascope.where{(id == id_query)}
        elsif (text =~ /^\s?(e\.?\s?(\d+))?(,?\s?v\.?\s?(\d+))?\s?$/)
          # Format: e(number), e(number)v(version) or v(version)
          qscope = ascope
          unless $1.nil?
            num_query = $2
            qscope = qscope.where(:number => num_query)
          end
          unless $3.nil?
            ver_query = $4
            qscope = qscope.where(:version => ver_query)
          end
        else # Invalid ID/Number
          return none
        end
      else # content/answers
        # Search by content
        query = '%' + text + '%'
        qscope = ascope.joins{questions.outer}
                   .joins{true_or_false_answers.outer}
                   .joins{multiple_choice_answers.outer}
                   .joins{matching_answers.outer}
                   .joins{fill_in_the_blank_answers.outer}
                   .joins{short_answers.outer}
                   .joins{free_response_answers.outer}
                   .where{(content =~ query) | \
                     (questions.content =~ query) | \
                     (true_or_false_answers.content =~ query) | \
                     (multiple_choice_answers.content =~ query) | \
                     (matching_answers.left_content =~ query) | \
                     (matching_answers.right_content =~ query) | \
                     (fill_in_the_blank_answers.pre_content =~ query) | \
                     (fill_in_the_blank_answers.blank_answer =~ query) | \
                     (fill_in_the_blank_answers.post_content =~ query) | \
                     (short_answers.content =~ query) | \
                     (short_answers.short_answer =~ query) | \
                     (free_response_answers.content =~ query) | \
                     (free_response_answers.free_response =~ query)}
      end
    end

    # Remove old published versions
    qscope = qscope.latest if latest_only

    # Remove duplicates
    qscope.group(:id)
  end

end
