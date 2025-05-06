module Content
  def self.slugs_by_page_uuid
    # RequestStore ensures we only load this once per request
    # Otherwise we load it from the cache (Redis in actual servers) until the ABL changes
    RequestStore.store[:slugs_by_page_uuid] ||= Rails.cache.fetch(
      "slugs_by_page_uuid/#{OpenStax::Content::Abl.new.digest}"
    ) { OpenStax::Content::Abl.new.slugs_by_page_uuid }
  end
end
