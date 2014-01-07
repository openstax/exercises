class Question < ActiveRecord::Base
  # attachable :exercise
  # content
  sortable :part_id

  belongs_to :part, :inverse_of => :questions
  belongs_to :format, polymorphic: true

  accepts_nested_attributes_for :format

  validates_presence_of :part
  
  delegate :can_be_read_by?, 
           :can_be_created_by?, 
           :can_be_updated_by?, 
           :can_be_destroyed_by?, 
           to: :part
end


  # has_many :dependent_question_pairs,
  #          :class_name => "QuestionDependencyPair",
  #          :foreign_key => "independent_question_id",
  #          :dependent => :destroy,
  #          :inverse_of => :independent_question
  # has_many :dependent_questions,
  #          :through => :dependent_question_pairs

  # has_many :independent_question_pairs,
  #          :class_name => "QuestionDependencyPair",
  #          :foreign_key => "dependent_question_id",
  #          :dependent => :destroy,
  #          :inverse_of => :dependent_question
  # has_many :independent_questions,
  #          :through => :independent_question_pairs

  # has_many :true_or_false_answers, :dependent => :destroy, :inverse_of => :question
  # has_many :multiple_choice_answers, :dependent => :destroy, :inverse_of => :question
  # has_many :matching_answers, :dependent => :destroy, :inverse_of => :question
  # has_many :fill_in_the_blank_answers, :dependent => :destroy, :inverse_of => :question
  # has_many :short_answers, :dependent => :destroy, :inverse_of => :question
  # has_many :free_response_answers, :dependent => :destroy, :inverse_of => :question

  # has_many :solutions, :through => :exercise

  # accepts_nested_attributes_for :true_or_false_answers, :allow_destroy => true
  # accepts_nested_attributes_for :multiple_choice_answers, :allow_destroy => true
  # accepts_nested_attributes_for :matching_answers, :allow_destroy => true
  # accepts_nested_attributes_for :fill_in_the_blank_answers, :allow_destroy => true
  # accepts_nested_attributes_for :short_answers, :allow_destroy => true
  # accepts_nested_attributes_for :free_response_answers, :allow_destroy => true

  # attr_accessible :credit, :true_or_false_answers_attributes, :multiple_choice_answers_attributes,
  #   :matching_answers_attributes, :fill_in_the_blank_answers_attributes, :short_answers_attributes, :free_response_answers_attributes


  # def has_correct_answers?
  #   return false if (multiple_choice_answers.first.nil? && \
  #                    matching_answers.first.nil? && \
  #                    fill_in_the_blank_answers.first.nil? && \
  #                    true_or_false_answers.first.nil? && \
  #                    short_answers.first.nil? && \
  #                    free_response_answers.first.nil?)

  #   unless multiple_choice_answers.first.nil?
  #     return false if multiple_choice_answers.where{credit > 0}.first.nil?
  #   end

  #   true
  # end

  # def has_blank_content?
  #   return true if content.blank?

  #   true_or_false_answers.each do |a|
  #     return true if a.content.blank?
  #   end

  #   multiple_choice_answers.each do |a|
  #     return true if a.content.blank?
  #   end

  #   matching_answers.each do |a|
  #     return true if a.left_content.blank? || a.right_content.blank?
  #   end

  #   fill_in_the_blank_answers.each do |a|
  #     return true if a.pre_content.blank? && a.post_content.blank?
  #   end

  #   false
  # end