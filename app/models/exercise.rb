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

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
  has_many :lists, :through => :list_exercises

  attr_accessible :only_embargo_solutions, :credit

  ##################
  # Access Control #
  ##################

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
