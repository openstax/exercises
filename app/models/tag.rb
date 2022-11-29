class Tag < ApplicationRecord

  has_many :exercise_tags
  has_many :vocab_term_tags

  validates :name, presence: true, uniqueness: true, format: /\A[\w\.:#\/-]*\z/

  def self.sanitize_name(name)
    name.to_s.gsub(/[^\w\.:#\/]+/, '-').gsub(/(?:\A-|-\z)/, '')
  end

  def self.get(tags)
    # Initialize array of remaining tags
    remaining_tags = [tags].flatten.compact

    # Get Tag objects in the given array
    result = remaining_tags.select { |tag| tag.is_a?(Tag) }
    remaining_tags = (remaining_tags - result).map do |tag|
      sanitized_name = sanitize_name(tag)
      sanitized_name unless sanitized_name.blank?
    end.compact.uniq

    # Get Tag objects in the database that match the given array
    db_result = where(name: remaining_tags).to_a
    result = result + db_result
    remaining_tags -= db_result.map(&:name)

    # Initialize remaining Tag objects
    result + remaining_tags.map { |tag| Tag.new(name: tag) }
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
