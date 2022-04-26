module Content
  def self.slugs_by_page_uuid
    # RequestStore ensures we only load this once per request
    # Otherwise we load it from the cache (Redis in actual servers) until the ABL changes
    RequestStore.store[:slugs_by_page_uuid] ||= Rails.cache.fetch(
      "slugs_by_page_uuid/#{OpenStax::Content::Abl.new.digest}"
    ) do
      {}.tap do |hash|
        books = OpenStax::Content::Abl.new.approved_books

        until books.empty?
          previous_version = nil
          previous_archive = nil
          retry_books = []

          books.each do |book|
            begin
              pages = book.all_pages
            rescue StandardError => exception
              # Sometimes books in the ABL fail to load
              # Retry with an earlier version of archive, if possible
              previous_version ||= book.archive.previous_version

              if previous_version.nil?
                raise exception
              else
                previous_archive ||= OpenStax::Content::Archive.new version: previous_version

                retry_books << OpenStax::Content::Book.new(
                  archive: previous_archive,
                  uuid: book.uuid,
                  version: book.version,
                  slug: book.slug,
                  style: book.style
                )
              end
            else
              pages.each do |page|
                hash[page.uuid] ||= []
                hash[page.uuid] << { book: book.slug, page: page.slug }
              end
            end
          end

          books = retry_books
        end
      end
    end
  end
end
