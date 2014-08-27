class Solution < ActiveRecord::Base

  publishable :question
  logicable

  belongs_to :question, inverse_of: :solutions
  has_one :exercise, through: :question

  validates :question, presence: true

  scope :visible_for, lambda { |user|
    escope = where{exercise_id.in my{Exercise.visible_for(user).collect{|e| e.id}}}

    return escope.published if user.nil?
    return escope if user.is_admin?

    escope.joins{collaborators.outer.deputies.outer}\
      .where{(published_at != nil) |\
      (collaborators.user_id == user.id) |\
      (collaborators.deputies.id == user.id)}\
      .group(:id)
  }

  scope :valid_for, lambda { |e|
    sb = e.solutions_bucket
    vscope = joins(:exercise).where(:exercise => {:number => e.number})
    vscope = vscope.where{exercise.version >= my{sb.first}} unless sb.first.nil?
    vscope = vscope.where{exercise.version < my{sb.last}} unless sb.last.nil?
    vscope
  }

  def to_param
    if is_published?
      "s#{number}v#{version}"
    else
      "s#{id}d"
    end
  end

  def name
    to_param
  end

  def has_blank_content?
    content.blank?
  end

  def self.from_param(param)
    if (param =~ /^s(\d+)d$/)
      s = not_published.where(:id => $1.to_i)
    elsif (param =~ /^s(\d+)(v(\d+))?$/)
      s = published.where(:number => $1.to_i)
      if $2.nil?
        s = s.latest
      else
        s = s.where(:version => $3.to_i)
      end
    elsif (param =~ /^(\d+)$/)
      s = where(:id => $1.to_i)
    else
      raise SecurityTransgression
    end
    
    s = s.first
    raise ActiveRecord::RecordNotFound if s.nil?
    s
  end

  def self.search(text, part, type, exercise_id, user)
    case type
    when 'published solutions'
      tscope = visible_for(user).published
    when 'draft solutions'
      tscope = visible_for(user).not_published
    when 'solutions for exercises in my lists'
      tscope = user.nil? ? none : user.listed_solutions
    else # all solutions
      tscope = visible_for(user)
    end

    tscope = tscope.where(:exercise_id => exercise_id) unless exercise_id.nil?

    latest_only = true
    if text.blank?
      qscope = tscope
    else
      text = text.gsub('%', '')

      case part
      when 'tags'
        # Search by tags
        qscope = tscope.joins{taggings.tag}
        text.split(",").each do |t|
          query = t.blank? ? '%' : '%' + t + '%'
          qscope = qscope.where{tags.name =~ query}
        end
      when 'author/copyright holder'
        # Search by author (or copyright holder)
        qscope = tscope.joins{collaborators.user}
        text.gsub(",", " ").split.each do |t|
          query = t.blank? ? '%' : '%' + t + '%'
          qscope = qscope.where{(collaborators.user.first_name =~ query) |\
                                (collaborators.user.last_name =~ query)}
        end
      when 'ID/number'
        # Search by solution ID or number
        latest_only = false
        if (text =~ /^\s?(\d+)\s?$/) # Format: (id or number)
          id_query = $1
          num_query = $1
          qscope = tscope.where{(id == id_query) | (number == num_query)}
        elsif (text =~ /^\s?s(\d+)d\s?$/) # Format: s(id)d
          id_query = $1
          qscope = tscope.where{(id == id_query)}
        elsif (text =~ /^\s?(s\.?\s?(\d+))?(,?\s?v\.?\s?(\d+))?\s?$/)
          # Format: s(number), s(number)v(version) or v(version)
          qscope = tscope
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
      else # summary/detailed explanation
        # Search by content
        query = '%' + text + '%'
        qscope = tscope.where{(summary =~ query) | (content =~ query)}
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
    exercise.can_be_read_by?(user) && (is_published? || has_collaborator?(user))
  end
  
  def can_be_updated_by?(user)
    exercise.can_be_read_by?(user) && (!is_published? || has_collaborator?(user))
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end
end
