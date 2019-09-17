class Admin::AddCollaborator
  lev_routine

  def exec(publishables:, user:, collaborator_type:)
    publishables.find_in_batches do |publishables|
      authors = []
      copyright_holders = []

      publishables.each do |publishable|
        publication = publishable.publication

        authors << Author.new(
          user_id: user.id,
          publication_id: publication.id,
          sort_position: publication.authors.size + 1
        ) if (collaborator_type == 'Author' || collaborator_type == 'Both') &&
             publication.authors.none? { |author| author.user_id == user.id }

        copyright_holders << CopyrightHolder.new(
          user_id: user.id,
          publication_id: publication.id,
          sort_position: publication.copyright_holders.size + 1
        ) if (collaborator_type == 'Copyright Holder' || collaborator_type == 'Both') &&
             publication.copyright_holders.none? { |ch| ch.user_id == user.id }
      end

      Author.import(authors, validate: false) unless authors.empty?
      CopyrightHolder.import(copyright_holders, validate: false) unless copyright_holders.empty?
    end
  end
end
