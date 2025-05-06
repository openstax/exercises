# Finds an approved book with the given UUID in the ABL that can be loaded
class FindBook
  lev_routine express_output: :book

  protected

  def exec(uuid:, archive_version: nil)
    if archive_version.nil?
      s3 = OpenStax::Content::S3.new
      raise 'Content bucket not configured' unless s3.bucket_configured?
      archive_version ||= s3.ls.last
    end
    archive = OpenStax::Content::Archive.new(version: archive_version)
    book = OpenStax::Content::Abl.new.books(archive: archive).find do |book|
      book.uuid == uuid
    end

    raise ArgumentError, "No book found with UUID \"#{uuid}\"" if book.nil?

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
