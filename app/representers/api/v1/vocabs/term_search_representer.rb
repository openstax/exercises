module Api::V1::Vocabs
  class TermSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: VocabTerm,
                       extend: TermRepresenter

    def to_hash(options = {})
      # Check if any VocabTerms are not cached
      all_cache_keys = TermWithDistractorsAndExerciseIdsRepresenter.all_cache_keys_for_array(
        items, options
      )
      existing_cache_keys = Rails.cache.read_multi(*all_cache_keys).keys

      uncached_items = items.reject do |item|
        TermWithDistractorsAndExerciseIdsRepresenter.all_cache_keys_for(item, options).all? do |key|
          existing_cache_keys.include? key
        end
      end

      # Preload necessary records for any uncached VocabTerms
      ActiveRecord::Associations::Preloader.new.preload(
        uncached_items, VocabTerm::PRELOAD_ASSOCIATIONS
      )

      super(options)
    end

  end
end
