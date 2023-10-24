# Finds an approved book with the given UUID in the ABL that can be loaded
class FindBook
  lev_routine express_output: :book

  protected

  def exec(uuid:, archive_version: nil)
    archive_version ||= OpenStax::Content::S3.new.ls.last
    archive = OpenStax::Content::Archive.new(version: archive_version)
    book = OpenStax::Content::Abl.new.approved_books(archive: archive).find do |book|
      book.uuid == uuid
    end

    loop do
      begin
        book.tree
      rescue StandardError => exception
        # Sometimes books in the ABL fail to load
        # Retry with an earlier version of archive, if possible
        previous_version ||= book.archive.previous_version

        # break from the loop if there are no more archive versions to try
        raise exception if previous_version.nil?

        previous_archive ||= OpenStax::Content::Archive.new version: previous_version

        book = OpenStax::Content::Book.new(
          archive: previous_archive,
          uuid: book.uuid,
          version: book.version,
          slug: book.slug,
          style: book.style,
          min_code_version: book.min_code_version,
          committed_at: book.committed_at
        )

        raise exception unless book.valid?
      else
        outputs.book = book
        return
      end
    end
  end
end
