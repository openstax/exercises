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

  has_many :true_or_false_answers, :through => :questions
  has_many :multiple_choice_answers, :through => :questions
  has_many :matching_answers, :through => :questions
  has_many :fill_in_the_blank_answers, :through => :questions
  has_many :short_answers, :through => :questions
  has_many :free_response_answers, :through => :questions

  has_many :solutions, :through => :questions

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
  has_many :lists, :through => :list_exercises

  accepts_nested_attributes_for :questions, :allow_destroy => true

  attr_accessible :embargo_days, :only_embargo_solutions, :credit, :questions_attributes

  validate :valid_embargo

  scope :not_published, where(:published_at => nil)
  scope :published, where{published_at != nil}
  scope :not_embargoed, where{(embargoed_until == nil) | (embargoed_until < Date.current)}
  scope :latest, joins{same_number}
                   .where{(id == same_number.id) | (same_number.published_at != nil)}
                   .group(:id).having{version >= max(same_number.version)}

  scope :visible_for, lambda { |user|
    return published.not_embargoed if user.nil?
    return scoped if user.is_admin?

    joins{lists.outer.users.outer.deputies.outer}\
    .joins{collaborators.outer.deputies.outer}\
    .where{((published_at != nil) &\
    ((embargoed_until == nil) |\
    (embargoed_until < Date.current))) |\
    ((list.users.id == user.id) |\
    (collaborators.user_id == user.id) |\
    (collaborators.deputies.id == user.id))}
  }

  scope :with_true_or_false_answers, joins(:true_or_false_answers)
  scope :with_multiple_choice_answers, joins(:multiple_choice_answers)
  scope :with_matching_answers, joins(:matching_answers)
  scope :with_fill_in_the_blank_answers, joins(:fill_in_the_blank_answers)
  scope :with_short_answers, joins(:short_answers)
  scope :with_free_response_answers, joins(:free_response_answers)

  def name
    "e#{number}v#{version}"
  end

  def summary
    summary_string = (content.blank? ? "" : content[0..15] + (content.length > 16 ? ' ...' : ''))

    question_count = questions.count
    return summary_string if question_count == 0
    return summary_string + " [#{question_count.to_s} questions]" if question_count > 1

    summary_string + " #{questions.first.summary}"
  end

  def is_embargoed?
    !embargoed_until.nil? && (embargoed_until >= Date.current)
  end

  def embargo_status
    if is_published?
      if embargoed_until.nil?
        'This exercise was not embargoed.'
      else
        if embargoed_until >= Date.current
          (only_embargo_solutions ? 'Solutions for this exercise are' : 'This exercise is') +
          " embargoed until #{embargoed_until}."
        else
          (only_embargo_solutions ? 'Solution' : 'Exercise') +
          " embargo expired on #{embargoed_until}."
        end
      end
    else
      if embargo_days == 0
        'This exercise will not be embargoed.'
      else
        (only_embargo_solutions ? 'Solutions for this' : 'This') +
        " exercise will be embargoed until #{Date.current + embargo_days.days} if published today."
      end
    end
  end

  def self.search(text, part, type, answer_type, user)
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

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    (is_published? && !is_embargoed?) || (!lists.first.nil? && lists.first.can_be_read_by?(user)) || has_collaborator?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil? && !is_published?
  end
  
  def can_be_updated_by?(user)
    !is_published? && !lists.first.nil? && \
    (lists.first.can_be_edited_by?(user) || has_collaborator?(user))
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

  def valid_embargo
    if embargo_days.between?(0, 180)
      embargoed_until = (embargo_days == 0 ? nil : ((published_at.nil? ? Date.current : published_at) + embargo_days.days))
      return
    end
    errors.add(:base, "Embargoes can only last from 0 to 180 days.")
    false
  end
end
