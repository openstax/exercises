module Content
  def self.slugs_by_page_uuid
    # RequestStore ensures we only load this once per request
    # Otherwise we load it from the cache (Redis in actual servers) until the ABL changes (or it expires)
    return RequestStore.store[:slugs_by_page_uuid] if RequestStore.store[:slugs_by_page_uuid]

    abl = OpenStax::Content::Abl.new
    cache_key = "slugs_by_page_uuid/#{abl.digest}"

    cached_value = Rails.cache.read(cache_key)
    return RequestStore.store[:slugs_by_page_uuid] = cached_value unless cached_value.nil?

    # Fall through to calculating again
    result = abl.slugs_by_page_uuid
    # If a book was broken, cache less greedily to try to find it again
    cache_options = abl.partial_data ? { expires_in: 30.minutes } : {}
    Rails.cache.write(cache_key, result, **cache_options)

    RequestStore.store[:slugs_by_page_uuid] = result
  end
end
