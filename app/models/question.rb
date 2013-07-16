class Question < ActiveRecord::Base
  attachable :exercise
  content
  sortable :exercise_id

  belongs_to :exercise, :inverse_of => :questions

  has_many :dependent_question_pairs,
           :class_name => "QuestionDependencyPair",
           :foreign_key => "independent_question_id",
           :dependent => :destroy,
           :inverse_of => :independent_question
  has_many :dependent_questions,
           :through => :dependent_question_pairs

  has_many :independent_question_pairs,
           :class_name => "QuestionDependencyPair",
           :foreign_key => "dependent_question_id",
           :dependent => :destroy,
           :inverse_of => :dependent_question
  has_many :independent_questions,
           :through => :independent_question_pairs

  has_many :multiple_choice_answers, :dependent => :destroy, :inverse_of => :question
  has_many :matching_answers, :dependent => :destroy, :inverse_of => :question
  has_many :fill_in_the_blank_answers, :dependent => :destroy, :inverse_of => :question
  has_many :true_or_false_answers, :dependent => :destroy, :inverse_of => :question
  has_many :short_answers, :dependent => :destroy, :inverse_of => :question
  has_many :free_response_answers, :dependent => :destroy, :inverse_of => :question

  has_many :solutions, :dependent => :destroy, :inverse_of => :question

  attr_accessible :changes_solution, :credit

  validates_presence_of :exercise

  amoeba do
    include_field [:dependent_question_pairs, :independent_question_pairs,
      :multiple_choice_answers, :matching_answers, :fill_in_the_blank_answers,
      :true_or_false_answers, :short_answers, :free_response_answers, :solutions]
  end

  ##################
  # Access Control #
  ##################

  protected

  def has_correct_answers?
    return false if (multiple_choice_answers.first.nil? && \
                     matching_answers.first.nil? && \
                     fill_in_the_blank_answers.first.nil? && \
                     true_or_false_answers.first.nil? && \
                     short_answers.first.nil? && \
                     free_response_answers.first.nil?)

    unless multiple_choice_answers.first.nil?
      return false if multiple_choice_answers.where{credit > 0}.first.nil?
    end

    true
  end
end
