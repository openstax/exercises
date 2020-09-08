class Admin::AddCollaborator
  lev_routine

  def exec(publishables:, user:, collaborator_type:)
    args = publishables.respond_to?(:find_in_batches) ? [ :find_in_batches ] : [ :each_slice, 1000 ]

    outputs.total_count = 0

    publishables.send(*args) do |publishables|
      authors = []
      copyright_holders = []

      publishables.each do |publishable|
        publication = publishable.publication

        authors << Author.new(
          user_id: user.id,
          publication_id: publication.id,
          sort_position: (publication.authors.map(&:sort_position).max || 0) + 1
        ) if (collaborator_type == 'Author' || collaborator_type == 'Both') &&
             publication.authors.none? { |author| author.user_id == user.id }

        copyright_holders << CopyrightHolder.new(
          user_id: user.id,
          publication_id: publication.id,
          sort_position: (publication.copyright_holders.map(&:sort_position).max || 0) + 1
        ) if (collaborator_type == 'Copyright Holder' || collaborator_type == 'Both') &&
             publication.copyright_holders.none? { |ch| ch.user_id == user.id }
      end

      outputs.total_count += authors.size + copyright_holders.size

      Author.import(authors, validate: false) unless authors.empty?
      CopyrightHolder.import(copyright_holders, validate: false) unless copyright_holders.empty?
    end

    publishables.respond_to?(:touch_all) ? publishables.touch_all : publishables.each(&:touch)
  end
end
