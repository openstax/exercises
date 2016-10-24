class CommunitySolution < ActiveRecord::Base
  publishable
  solution

  scope :visible_for, ->(user) {
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next none if !user.is_a?(User) || user.is_anonymous?
    next self if user.administrator
    user_id = user.id

    joins do
      [
        publication.authors,
        publication.copyright_holders,
        publication.publication_group.list_publication_groups.outer.list.outer.list_owners,
        publication.publication_group.list_publication_groups.outer.list.outer.list_editors,
        publication.publication_group.list_publication_groups.outer.list.outer.list_readers
      ].map(&:outer)
    end.where do
      (authors.user_id           == user_id                                        ) |
      (copyright_holders.user_id == user_id                                        ) |
      ((list_owners.owner_id     == user_id) & (list_owners.owner_type   == 'User')) |
      ((list_editors.editor_id   == user_id) & (list_editors.editor_type == 'User')) |
      ((list_readers.reader_id   == user_id) & (list_readers.reader_type == 'User'))
    end
  }
  scope :visible_for, ->(user) {
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next none if !user.is_a?(User) || user.is_anonymous?
    next self if user.administrator
    user_id = user.id

    joins{publication.authors.outer}
      .joins{publication.copyright_holders.outer}
      .where{ (authors.user_id == user_id) | (copyright_holders.user_id == user_id) }
  }
end
