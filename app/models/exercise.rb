require 'content'

class Exercise < ApplicationRecord
  EQUALITY_ASSOCIATIONS = [
    :logic,
    :tags,
    publication: [
      :publication_group,
      :license,
      derivations: :source_publication,
      authors: :user,
      copyright_holders: :user
    ],
    questions: [
      :collaborator_solutions,
      :hints,
      answers: :stem_answers,
      stems: [
        :stylings,
        :combo_choices
      ]
    ]
  ]

  EQUALITY_EXCLUDED_FIELDS = ['id', 'uuid', 'created_at', 'updated_at', 'version',
                              'published_at', 'yanked_at', 'embargoed_until']

  # deep_clone does not iterate through hashes, so each hash must have only 1 key
  NEW_VERSION_DUPED_ASSOCIATIONS = [
    :logic,
    :tags,
    {
      publication: [
        :derivations,
        :authors,
        :copyright_holders
      ]
    },
    {
      questions: [
        :hints,
        :answers,
        {
          collaborator_solutions: [
            :logic,
            :stylings
          ]
        },
        {
          stems: [
            :stylings,
            :combo_choices,
            stem_answers: :answer
          ]
        }
      ]
    }
  ]

  CACHEABLE_ASSOCIATIONS = [
    :logic,
    :tags,
    publication: [
      :derivations,
      authors: { user: :account },
      copyright_holders: { user: :account }
    ],
    questions: [
      :hints,
      :collaborator_solutions,
      :community_solutions,
      answers: :stem_answers,
      stems: [ :stylings, :combo_choices ]
    ]
  ]

  UNCACHEABLE_ASSOCIATIONS = [
    publication: [
      publication_group: :publications,
      authors: { user: :delegations_as_delegator },
      copyright_holders: { user: :delegations_as_delegator }
    ]
  ]

  acts_as_votable
  user_html :stimulus
  publishable
  has_attachments
  has_logic :javascript, :latex
  has_tags

  sortable_has_many :questions, dependent: :destroy, autosave: true, inverse_of: :exercise

  belongs_to :vocab_term, touch: true, optional: true

  scope :can_release_to_a15k, -> { where(release_to_a15k: true) }
  scope :not_released_to_a15k, -> { where(a15k_identifier: nil) }

  before_validation :set_context, :set_slug_tags!

  def content_equals?(other_exercise)
    return false unless other_exercise.is_a? ActiveRecord::Base

    association_attributes_arguments = [EQUALITY_ASSOCIATIONS, except: EQUALITY_EXCLUDED_FIELDS,
                                                               exclude_foreign_keys: true,
                                                               transform_arrays_into_sets: true]
    attrs = association_attributes(*association_attributes_arguments)
    other_attrs = other_exercise.association_attributes(*association_attributes_arguments)

    attrs == other_attrs
  end

  def flattened_content
    ([ context, stimulus ] + questions.map(&:flattened_content)).join("\n")
  end

  def new_version
    nv = deep_clone include: NEW_VERSION_DUPED_ASSOCIATIONS, use_dictionary: true
    nv.publication.uuid = nil
    nv.publication.version = nil
    nv.publication.published_at = nil
    nv.publication.yanked_at = nil
    nv.publication.embargoed_until = nil
    nv.publication.major_change = false
    images.each { |image| nv.images.attach image.blob }
    nv
  end

  def can_view_solutions?(user)
    return true if solutions_are_public # Public solutions
    return false if user.nil?           # User not given
    return true if new_record?          # Exercise being created

    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)

    # Modify the line below if we implement delegating to apps
    return true if user.nil?            # Application user
    return false if user.is_anonymous?  # Anonymous user

    has_read_permission?(user)          # Regular user
  end

  def is_vocab?
    vocab_term_id.present?
  end

  def before_publication
    # Check that all stems have either no answers (free response) or at least one correct answer
    questions.each do |question|
      question.stems.each do |stem|
        next if stem.stem_answers.empty? || stem.stem_answers.any?(&:is_correct?)
        errors.add(:base, 'has a question with only incorrect answers')
        throw(:abort)
      end
    end
  end

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    throw(:abort)
  end

  def rewrite_feature_link(link, webview_uri, archive)
    begin
      uri = Addressable::URI.parse link
    rescue InvalidURIError
      Rails.logger.warn { "Invalid url: \"#{link}\" in page: #{webview_uri.to_s}" }
      return link
    end

    if uri.absolute?
      # Force absolute URLs to be https
      uri.scheme = 'https'
      return uri.to_s
    end

    # Fragment-only URLs (links to the same page)
    if uri.path.blank?
      if webview_uri.nil?
        # Keep fragment-only URLs relative
        return link
      else
        # Absolutize fragment-only URLs
        uri.path = webview_uri.path
        uri.host = webview_uri.host
        uri.scheme = webview_uri.scheme
        return uri.to_s
      end
    end

    if uri.path.starts_with?('./')
      # Link to another book/page
      # The user might not have access to the book locally, so it's safer to send them to REX
      archive.webview_uri_for uri
    else
      # Resource link or other unknown relative link
      # Delegate to OpenStax::Content::Archive
      archive.url_for link
    end
  end

  def set_context(archive_version: nil)
    return if context_changed?

    tag_names = tags.map(&:name)
    cnxfeature_tags = tag_names.filter { |name| name.starts_with? 'context-cnxfeature:' }
    cnxmod_tags = tag_names.filter     { |name| name.starts_with? 'context-cnxmod:' }
    if cnxfeature_tags.empty? || cnxmod_tags.empty?
      self.context = nil
      return
    end

    s3 = OpenStax::Content::S3.new
    archive_version ||= s3.ls.last
    archive = OpenStax::Content::Archive.new version: archive_version
    cnxmod_tags.each do |cnxmod_tag|
      page_uuid = cnxmod_tag.sub 'context-cnxmod:', ''
      next if page_uuid.blank?

      page = s3.find_page page_uuid, archive_version: archive_version
      next if page.nil?

      node = Nokogiri::HTML.parse archive.json(page)['content']
      cnxfeature_tags.each do |cnxfeature_tag|
        feature_id = cnxfeature_tag.sub 'context-cnxfeature:', ''
        next if feature_id.blank?

        feature = node.at_css "##{feature_id}"
        next if feature.nil?

        webview_uri = archive.webview_uri_for page

        [ 'src', 'href' ].each do |attribute_name|
          feature.css("[#{attribute_name}]").each do |link|
            attribute = link.attributes[attribute_name]
            attribute.value = rewrite_feature_link attribute.value, webview_uri, archive
          end
        end

        self.context = feature.to_html
        return
      end
    end

    self.context = nil
    return
  end

  def set_slug_tags!
    existing_book_slug_tags, other_tags = tags.partition do |tag|
      tag.name.starts_with? 'book-slug:'
    end
    existing_page_slug_tags, non_slug_tags = other_tags.partition do |tag|
      tag.name.starts_with? 'module-slug:'
    end

    page_uuids = non_slug_tags.map(&:name).filter do |name|
      name.starts_with? 'context-cnxmod:'
    end.map { |cnxmod| cnxmod.sub 'context-cnxmod:', '' }.reject(&:blank?)

    desired_slug_hashes = page_uuids.flat_map do |page_uuid|
      Content.slugs_by_page_uuid[page_uuid] || []
    end

    desired_book_slugs = desired_slug_hashes.map { |slug| "book-slug:#{slug[:book]}" }.uniq
    desired_page_slugs = desired_slug_hashes.map do |slug|
      "module-slug:#{slug[:book]}:#{slug[:page]}"
    end

    kept_book_slug_tags, removed_book_slug_tags = existing_book_slug_tags.partition do |tag|
      desired_book_slugs.include? tag.name
    end
    kept_page_slug_tags, removed_page_slug_tags = existing_page_slug_tags.partition do |tag|
      desired_page_slugs.include? tag.name
    end

    existing_book_slugs = existing_book_slug_tags.map(&:name)
    existing_page_slugs = existing_page_slug_tags.map(&:name)

    new_book_slugs = desired_book_slugs.reject { |slug| existing_book_slugs.include? slug }
    new_page_slugs = desired_page_slugs.reject { |slug| existing_page_slugs.include? slug }

    self.tags = non_slug_tags +
                kept_book_slug_tags + kept_page_slug_tags +
                new_book_slugs + new_page_slugs

    # Return whether or not any tags changed
    !removed_book_slug_tags.empty? ||
    !removed_page_slug_tags.empty? ||
    !new_book_slugs.empty? ||
    !new_page_slugs.empty?
  end
end
