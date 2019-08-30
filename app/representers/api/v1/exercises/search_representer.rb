module Api::V1::Exercises
  class SearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: Exercise,
                       extend: Representer

    def to_hash(options = {})
      unless items.empty?
        preloader = ActiveRecord::Associations::Preloader.new

        # Preload associations that are uncacheable
        preloader.preload items, Exercise::UNCACHEABLE_ASSOCIATIONS

        # Check if any Exercises are not cached
        all_cache_keys = Representer.all_cache_keys_for_array items, options
        existing_cache_keys = Rails.cache.read_multi(*all_cache_keys).keys

        uncached_items = items.reject do |item|
          Representer.all_cache_keys_for(item, options).all? do |cache_key|
            existing_cache_keys.include? cache_key
          end
        end

        # Preload associations that are cache misses
        preloader.preload(
          uncached_items, Exercise::CACHEABLE_ASSOCIATIONS
        ) unless uncached_items.empty?
      end

      super(options)
    end

  end
end
