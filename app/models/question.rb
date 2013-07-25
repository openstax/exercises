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

  has_many :true_or_false_answers, :dependent => :destroy, :inverse_of => :question
  has_many :multiple_choice_answers, :dependent => :destroy, :inverse_of => :question
  has_many :matching_answers, :dependent => :destroy, :inverse_of => :question
  has_many :fill_in_the_blank_answers, :dependent => :destroy, :inverse_of => :question
  has_many :short_answers, :dependent => :destroy, :inverse_of => :question
  has_many :free_response_answers, :dependent => :destroy, :inverse_of => :question

  has_many :solutions, :dependent => :destroy, :inverse_of => :question

  attr_accessible :changes_solution, :credit

  validates_presence_of :exercise

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

  def has_blank_content?
    return true if content.blank?

    true_or_false_answers.each do |a|
      return true if a.content.blank?
    end

    multiple_choice_answers.each do |a|
      return true if a.content.blank?
    end

    matching_answers.each do |a|
      return true if a.left_content.blank? || a.right_content.blank?
    end

    fill_in_the_blank_answers.each do |a|
      return true if a.pre_content.blank? && a.post_content.blank?
    end

    false
  end
end
