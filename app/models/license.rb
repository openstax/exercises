class License < ActiveRecord::Base
  sortable

  serialize :can_combine_into

  has_many :exercises, :inverse_of => :license
  has_many :solutions, :inverse_of => :license
  has_many :rubrics, :inverse_of => :license

  validates_presence_of :name, :short_name, :url, :publishing_contract,
                        :copyright_notice, :can_combine_into
  validates_uniqueness_of :name, :short_name, :url

  scope :for_exercises, where(:allows_exercises => true)
  scope :for_solutions, where(:allows_solutions => true)
  scope :for_rubrics, where(:allows_rubrics => true)

  def valid_for?(publishable)
    case publishable.class
    when Exercise
      allows_exercises
    when Solution
      allows_solutions
    when Rubric
      allows_rubrics
    else
      false
    end
  end

  def self.options_for(publishable)
    case publishable.class
    when Exercise
      pscope = for_exercises
    when Solution
      pscope = for_solutions
    when Rubric
      pscope = for_rubrics
    else
      pscope = none
    end
    pscope.all.collect{|l| [l.short_name, l.id]}
  end
end
