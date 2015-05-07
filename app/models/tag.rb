class Tag < ActiveRecord::Base
  has_many :exercise_tags, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.get(tags)
    # Initialize array of remaining tags
    remaining_tags = [tags].flatten.compact

    # Get Tag objects in the given array
    result = remaining_tags.select{ |tag| tag.is_a?(Tag) }
    remaining_tags = remaining_tags.reject{ |tag| tag.is_a?(Tag) }.collect{ |tag| tag.to_s.downcase }

    # Get Tag objects in the database that match the given array
    db_result = where(name: remaining_tags).to_a
    result = result + db_result
    remaining_tags -= db_result.collect{ |r| r.name }

    # Initialize remaining Tag objects
    result + remaining_tags.collect{ |tag| Tag.new(name: tag) }
  end

  def ==(tag)
    name == tag || super
  end

  def eql?(tag)
    name.eql?(tag) || super
  end

  def to_s
    name.to_s
  end

  def inspect
    name.inspect
  end

  def pretty_print(q)
    q.pp name
  end

  def as_json(options = nil)
    name.as_json(options)
  end
end
