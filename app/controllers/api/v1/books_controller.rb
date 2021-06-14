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

    api :GET, '/books', 'Returns a list of books in the some archive version or latest'
    description 'Returns a list of books in the some archive version (defaults to latest version)'
    param :archive_version, String, desc: 'Archive code pipeline version (default: latest version)'
    def index
      OSU::AccessPolicy.require_action_allowed! :index, current_api_user, OpenStax::Content::Book

      render json: available_book_versions_by_uuid.to_h
    end

    ########
    # show #
    ########/

    api :GET, '/books/:uuid(/:version)', 'Returns a list of pages in some book version or latest'
    description 'Returns a list of pages in some book version (default: latest version)'
    param :archive_version, String, desc: 'Archive code pipeline version (default: latest version)'
    param :uuid, String, desc: 'Book uuid'
    param :version, String, desc: 'Book version (defaults to latest version)'
    def show
      OSU::AccessPolicy.require_action_allowed! :read, current_api_user, OpenStax::Content::Book

      uuid = params[:uuid]
      version = params[:version] || available_book_versions_by_uuid[uuid].last

      render json: OpenStax::Content::Book.new(
        archive_version: archive_version, uuid: uuid, version: version
      ).tree['contents']
    end


    protected

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

    def available_book_versions_by_uuid
      Hash.new { |hash, key| hash[key] = [] }.tap do |hash|
        s3.ls(archive_version).each do |book|
          uuid, version = book.split('@')
          hash[uuid] << version
        end
      end.tap do |hash|
        hash.values.each do |versions|
          versions.sort_by! { |version| version.split('.').map(&:to_i) }
        end
      end
    end
  end
end
