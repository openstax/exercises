class Exercise < ActiveRecord::Base
  attachable
  content
  publishable

  add_prepublish_check(:has_questions?, true, 'This exercise does not contain any questions.')
  add_prepublish_check(:has_correct_answers?, true, 'Some questions in this exercise do not have correct answers.')
  add_prepublish_check(:has_blank_content?, false, 'Some questions in this exercise have blank contents or answers.')

  dup_includes_array = [:attachments,
                        {:questions => [{:dependent_question_pairs => :dependent_question},
                                        {:independent_question_pairs => :independent_question},
                                        :true_or_false_answers,
                                        :multiple_choice_answers,
                                        :matching_answers,
                                        :fill_in_the_blank_answers,
                                        :short_answers,
                                        :free_response_answers]}]

  has_many :same_number, :class_name => 'Exercise', :primary_key => :number, :foreign_key => :number

  has_many :questions, :dependent => :destroy, :inverse_of => :exercise
  has_many :solutions, :through => :questions

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
  has_many :lists, :through => :list_exercises

  accepts_nested_attributes_for :questions, :allow_destroy => true

  attr_accessible :only_embargo_solutions, :credit, :questions_attributes

  scope :not_published, where(:published_at => nil)
  scope :published, where{published_at != nil}
  scope :latest, joins{same_number}
                   .where{(id == same_number.id) | (same_number.published_at != nil)}
                   .group(:id).having{version >= max(same_number.version)}

  #TODO
  scope :visible_for, lambda { |user|
    return published if user.nil?

    joins{list_exercises.outer.list.outer.user_groups.outer.user_group_users.outer}\
    .joins{collaborators.outer.user.outer.deputies.outer}\
    .where{(published_at == nil) |\
    (list_exercise.list.user_groups.user_group_users.user_id == user.id) |\
    (((question_collaborators.user_id == user.id) |\
    (question_collaborators.user.deputies.id == user.id)) &\
    ((question_collaborators.is_author == true) |\
    (question_collaborators.is_copyright_holder == true)))}
  }

  scope :none, where(:id => nil).where{id != nil}

  def summary
    summary_string = (content.blank? ? "" : content[0..15] + (content.length > 16 ? ' ...' : ''))

    question_count = questions.count
    return summary_string if question_count == 0
    return summary_string + " [#{question_count.to_s} questions]" if question_count > 1

    summary_string + " #{questions.first.summary}"
  end

  def is_embargoed?
    !embargoed_until.nil?
  end

  def self.search(text, part, type, answer_type, user)
    case type
    when 'published exercises'
      tscope = published
    when 'draft exercises'
      tscope = not_published
    when 'exercises in my lists'
      tscope = user.listed_exercises
    else # all exercises
      tscope = scoped
    end

    # TODO
    case answer_type
    when 'true or false answers'
    when 'multiple choice answers'
    when 'matching answers'
    when 'fill in the blank answers'
    when 'short answers'
    when 'free response answers'
    else # any answer types
      ascope = tscope
    end

    latest_only = true
    if text.blank?
      qscope = ascope
    else
      text = text.gsub("%", "")
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
        elsif (text =~ /^\s?e\.?\s?(\d+)(,?\s?v\.?\s?(\d+))?\s?$/)
          # Format: e(number) or e(number)v(version)
          num_query = $1
          qscope = ascope.where(:number => num_query)
          unless $2.nil?
            ver_query = $3
            qscope = qscope.where(:version => ver_query)
          end
        else # Invalid ID/Number
          return Exercise.none
        end
      else # content
        # Search by content
        query = '%' + text + '%'
        qscope = ascope.where{(content =~ query)}
      end
    end
    
    # Remove exercises the user can't read and duplicates
    sscope = qscope.visible_for(user).group(:id)

    # Remove old published versions
    sscope = sscope.latest if latest_only
    
    sscope
  end

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    is_published? || (!lists.first.nil? && lists.first.can_be_read_by?(user)) || has_collaborator?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil? && !is_published?
  end
  
  def can_be_updated_by?(user)
    !is_published? && !lists.first.nil? && \
    (lists.first.has_permission?(user, :editor) || \
    lists.first.has_permission?(user, :publisher) || \
    lists.first.has_permission?(user, :manager) || \
    has_collaborator?(user))
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end

  protected

  ###############
  # Validations #
  ###############

  def has_questions?
    !questions.first.nil?
  end

  def has_blank_content?
    return true if content.blank?

    questions.each do |q|
      return true if q.has_blank_content?
    end

    false
  end

  def has_correct_answers?
    return unless has_questions?

    questions.each do |q|
      return false unless q.has_correct_answers?
    end

    true
  end
end
