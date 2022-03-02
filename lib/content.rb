module Content
  def self.slugs_by_page_uuid
    # RequestStore ensures we only load this once per request
    # Otherwise we load it from the cache (Redis in actual servers) until the ABL changes
    RequestStore.store[:slugs_by_page_uuid] ||= Rails.cache.fetch(
      "slugs_by_page_uuid/#{OpenStax::Content::Abl.new.digest}"
    ) do
      {}.tap do |hash|
        OpenStax::Content::Abl.new.approved_books.each do |book|
          begin
            pages = book.all_pages
          rescue StandardError => exception
            # Sometimes books in the ABL fail to load
            # Log it, but keep going
            Rails.logger.error exception
          else
            pages.each do |page|
              hash[page.uuid] ||= []
              hash[page.uuid] << { book: book.slug, page: page.slug }
            end
          end
        end
      end
    end
  end
end
