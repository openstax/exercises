module Api::V1
  class BooksController < OpenStax::Api::V1::ApiController
    before_action :abort_unless_bucket_configured

    resource_description do
      api_versions 'v1'
      short_description 'Lists of OpenStax books and pages in each book'
      description 'Returns lists of OpenStax books and pages in each book'
    end

    #########
    # index #
    #########

    api :GET, '/books', 'Returns a list of books in both the ABL and some archive version or latest'
    description 'Returns a list of books in both the ABL and some archive version (default: latest)'
    param :archive_version, String, desc: 'Archive code pipeline version (default: latest version)'
    def index
      OSU::AccessPolicy.require_action_allowed! :index, current_api_user, OpenStax::Content::Book

      books = abl.approved_books(archive: archive).group_by(&:uuid).map do |uuid, books|
        latest_book = books.sort_by(&:committed_at).last

        # We use book.slug.titleize here to avoid fetching all book ToCs,
        # because the actual book title is not in the ABL
        {
          uuid: latest_book.uuid,
          version: latest_book.version,
          title: latest_book.slug.titleize,
          slug: latest_book.slug
        }
      end

      render json: books
    end

    ########
    # show #
    ########/

    api :GET, '/books/:uuid', 'Returns a list of pages in some book'
    description 'Returns a list of pages in some book in some archive version (default: latest)'
    param :archive_version, String, desc: 'Archive code pipeline version (default: latest version)'
    param :uuid, String, desc: 'Book uuid'
    def show
      OSU::AccessPolicy.require_action_allowed! :read, current_api_user, OpenStax::Content::Book

      book = abl.approved_books(archive: archive).find { |book| book.uuid == params[:uuid] }
      tree = []

      loop do
        begin
          tree = book.tree['contents']
        rescue StandardError => exception
          # Sometimes books in the ABL fail to load
          # Retry with an earlier version of archive, if possible
          previous_version ||= book.archive.previous_version

          # break from the loop if there are no more archive versions to try
          break if previous_version.nil?

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
        else
          # break from the loop if successful
          break
        end
      end

      render json: tree
    end

    protected

    def abl
      @abl ||= OpenStax::Content::Abl.new
    end

    def s3
      @s3 ||= OpenStax::Content::S3.new
    end

    def abort_unless_bucket_configured
      return if s3.bucket_configured?

      render json: { error: 'Content bucket not configured' }, status: 500
    end

    def archive_version
      @archive_version ||= params[:archive_version] || s3.ls.last
    end

    def archive
      @archive ||= OpenStax::Content::Archive.new(version: archive_version)
    end
  end
end
