class Admin::RemoveCollaborator
  lev_routine

  def exec(publishables:, user:, collaborator_type:)
    publishables.find_in_batches do |publishables|
      author_ids = []
      copyright_holder_ids = []

      publishables.each do |publishable|
        publication = publishable.publication

        if collaborator_type == 'Author' || collaborator_type == 'Both'
          author = publication.authors.find do |author|
            author.user_id == user.id
          end

          author_ids << author.id unless author.nil?
        end

        if collaborator_type == 'Copyright Holder' || collaborator_type == 'Both'
          copyright_holder = publication.copyright_holders.find do |copyright_holder|
            copyright_holder.user_id == user.id
          end

          copyright_holder_ids << copyright_holder.id unless copyright_holder.nil?
        end
      end

      Author.where(id: author_ids).delete_all unless author_ids.empty?
      CopyrightHolder.where(id: copyright_holder_ids).delete_all unless copyright_holder_ids.empty?
    end
  end
end
