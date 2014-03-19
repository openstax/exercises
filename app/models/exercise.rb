class Exercise < ActiveRecord::Base
  attachable
  # credit
  # content
  publishable

  add_prepublish_check(:has_questions?, true, 'This exercise does not contain any questions.')
  add_prepublish_check(:has_correct_answers?, true, 'Some questions in this exercise do not have correct answers.')
  add_prepublish_check(:has_blank_content?, false, 'This exercise or some of its questions have blank content or answers.')

  add_dup_include({:questions => [{:dependent_question_pairs => :dependent_question},
                                  {:independent_question_pairs => :independent_question},
                                   :true_or_false_answers,
                                   :multiple_choice_answers,
                                   :matching_answers,
                                   :fill_in_the_blank_answers,
                                   :short_answers,
                                   :free_response_answers]})
  add_dup_exception(:changes_solutions)

  has_many :parts, dependent: :destroy, inverse_of: :exercise
  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
  has_many :lists, :through => :list_exercises
  belongs_to :background, class_name: 'Content', dependent: :destroy
  belongs_to :logic, dependent: :destroy

  accepts_nested_attributes_for :background, :logic

  # accepts_nested_attributes_for :parts
  # attr_accessible :parts_attributes

  attr_accessible :changes_solutions, :embargo_days, :only_embargo_solutions, :background_attributes

  validate :valid_embargo

  def self.not_embargoed
    where{(embargoed_until == nil) | (embargoed_until < Date.current)}
  end

  def self.visible_for(user)
    return published.not_embargoed if user.nil?
    return scoped if user.is_admin?

    joins{lists.outer.users.outer.deputies.outer}\
      .joins{collaborators.outer.deputies.outer}\
      .where{((published_at != nil) &\
      ((embargoed_until == nil) |\
      (embargoed_until < Date.current))) |\
      ((list.users.id == user.id) |\
      (collaborators.user_id == user.id) |\
      (collaborators.deputies.id == user.id))}\
      .group(:id)
  end

  scope :with_true_or_false_answers, joins(:true_or_false_answers)
  scope :with_multiple_choice_answers, joins(:multiple_choice_answers)
  scope :with_matching_answers, joins(:matching_answers)
  scope :with_fill_in_the_blank_answers, joins(:fill_in_the_blank_answers)
  scope :with_short_answers, joins(:short_answers)
  scope :with_free_response_answers, joins(:free_response_answers)

  def to_param
    if is_published?
      "e#{number}v#{version}"
    else
      "e#{id}d"
    end
  end

  def name
    to_param
  end

  def summary
    return "NYI"
    summary_string = (content.blank? ? "" : content[0..15] + (content.length > 16 ? ' ...' : ''))

    question_count = questions.count
    return summary_string if question_count == 0
    return summary_string + " [#{question_count.to_s} questions]" if question_count > 1

    summary_string + " #{questions.first.summary}"
  end

  def is_embargoed?
    !embargoed_until.nil? && (embargoed_until >= Date.current)
  end

  def solutions_bucket
    same_number_changes_solutions = Exercise.where(:number => number).where(:changes_solutions => true)
    minimum_version = same_number_changes_solutions.where{version <= my{version}}.first.try(:version)
    maximum_version = same_number_changes_solutions.where{version > my{version}}.last.try(:version)
    [minimum_version, maximum_version]
  end

  def self.from_param(param)
    if (param =~ /^e(\d+)d$/)
      e = not_published.where(:id => $1.to_i)
    elsif (param =~ /^e(\d+)(v(\d+))?$/)
      e = published.where(:number => $1.to_i)
      if $2.nil?
        e = e.latest
      else
        e = e.where(:version => $3.to_i)
      end
    elsif (param =~ /^(\d+)$/)
      e = where(:id => $1.to_i)
    else
      raise SecurityTransgression
    end

    e = e.first
    raise ActiveRecord::RecordNotFound if e.nil?
    e
  end



  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    (is_published? && !is_embargoed?) || (!lists.first.nil? && lists.first.can_be_read_by?(user)) || has_collaborator?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil? && (number == nil || (!same_number.latest.first.nil? && same_number.latest.first.can_be_edited_by?(user)))
  end
  
  def can_be_updated_by?(user)
    !is_published? && ((!lists.first.nil? && \
    lists.first.can_be_edited_by?(user)) || \
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

  # def has_correct_answers?
  #   questions.each do |q|
  #     return false unless q.has_correct_answers?
  #   end

  #   true
  # end

  def valid_embargo
    if embargo_days.between?(0, 180)
      self.embargoed_until = (embargo_days == 0 ? nil : ((published_at.nil? ? Date.current : published_at) + embargo_days.days))
      return
    end
    errors.add(:embargo_days, "out of allowed range.")
    false
  end
end
