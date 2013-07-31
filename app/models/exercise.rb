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

  has_many :questions, :dependent => :destroy, :inverse_of => :exercise
  has_many :solutions, :through => :questions

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
  has_many :lists, :through => :list_exercises

  accepts_nested_attributes_for :questions, :allow_destroy => true

  attr_accessible :only_embargo_solutions, :credit, :questions_attributes

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
