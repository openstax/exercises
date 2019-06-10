module Api::V1::Exercises
  class Representer < BaseRepresenter

    # Attachments may (for a while) contain collaborator solution attachments, so
    # only show them to those who can see solutions
    has_attachments(if: SOLUTIONS)

    has_logic(if: NOT_SOLUTIONS_ONLY)
    has_tags(if: NOT_SOLUTIONS_ONLY)

    publishable(if: NOT_SOLUTIONS_ONLY)

    property :is_vocab?,
             as: :is_vocab,
             writeable: false,
             readable: true,
             if: NOT_SOLUTIONS_ONLY

    property :vocab_term_uid,
             type: Integer,
             writeable: false,
             readable: true,
             getter: ->(*) { vocab_term.try!(:uid) },
             if: SOLUTIONS

    property :title,
             type: String,
             writeable: true,
             readable: true,
             if: NOT_SOLUTIONS_ONLY

    property :stimulus,
             as: :stimulus_html,
             type: String,
             writeable: true,
             readable: true,
             if: NOT_SOLUTIONS_ONLY

    collection :questions,
               instance: ->(*) { Question.new(exercise: self) },
               extend: ->(input:, **) {
                 input.nil? || input.stems.length > 1 ? \
                   QuestionRepresenter : SimpleQuestionRepresenter
               },
               writeable: true,
               readable: true,
               setter: AR_COLLECTION_SETTER,
               schema_info: {
                 required: true
               }

    collection :versions,
             type: Array,
             writeable: false,
             readable: true,
             getter: ->(user_options:, **) do
               visible_versions(can_view_solutions: SOLUTIONS.call(user_options: user_options))
             end

    def self.cache_key_types_for(represented, options = {})
      user_options = options.fetch(:user_options, {})

      [ 'no_solutions' ].tap do |types|
        types << 'solutions_only' if user_options[:can_view_solutions] ||
                                     represented.can_view_solutions?(user_options[:user])
      end
    end

    def self.cache_key_for(represented, type)
      "#{represented.cache_key}/#{represented.cache_version}/#{type}"
    end

    def self.all_cache_keys_for(represented, options = {})
      cache_key_types_for(represented, options).map { |type| cache_key_for represented, type }
    end

    def self.all_cache_keys_for_array(represented_array, options = {})
      represented_array.flat_map { |represented| all_cache_keys_for represented, options }
    end

    # Like Hash#deep_merge but also handles arrays
    def recursive_merge(enum1, enum2)
      return enum2 if enum1.nil?
      return enum1 if enum2.nil?

      case enum2
      when ::Hash
        enum1.dup.tap do |result_hash|
          enum2.each { |key, value| result_hash[key] = recursive_merge result_hash[key], value }
        end
      when ::Array
        max_index = [enum1.length, enum2.length].max
        max_index.times.map { |index| recursive_merge enum1[index], enum2[index] }
      else
        enum2
      end
    end

    def to_hash(options = {})
      user_options = options.fetch(:user_options, {})

      no_solutions = Rails.cache.fetch(
        self.class.cache_key_for(represented, 'no_solutions'), expires_in: NEVER_EXPIRES
      ) { super(options.merge(user_options: user_options.merge(no_solutions: true))) }

      return no_solutions unless user_options[:can_view_solutions] ||
                                 represented.can_view_solutions?(user_options[:user])

      solutions_only = Rails.cache.fetch(
        self.class.cache_key_for(represented, 'solutions_only'), expires_in: NEVER_EXPIRES
      ) { super(options.merge(user_options: user_options.merge(solutions_only: true))) }

      recursive_merge(no_solutions.except(:versions), solutions_only)
    end

  end
end
