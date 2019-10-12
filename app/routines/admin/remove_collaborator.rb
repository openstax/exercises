class Admin::RemoveCollaborator
  lev_routine

  def exec(publishables:, user:, collaborator_type:)
    args = publishables.respond_to?(:find_in_batches) ? [ :find_in_batches ] : [ :each_slice, 1000 ]

    outputs.total_count = 0

    publishables.send(*args) do |publishables|
      author_ids = []
      copyright_holder_ids = []

      publishables.each do |publishable|
        publication = publishable.publication

        if (collaborator_type == 'Author' || collaborator_type == 'Both') &&
           publication.authors.length > 1
          author = publication.authors.find do |author|
            author.user_id == user.id
          end

          author_ids << author.id unless author.nil?
        end

        if (collaborator_type == 'Copyright Holder' || collaborator_type == 'Both') &&
           publication.copyright_holders.length > 1
          copyright_holder = publication.copyright_holders.find do |copyright_holder|
            copyright_holder.user_id == user.id
          end

          copyright_holder_ids << copyright_holder.id unless copyright_holder.nil?
        end
      end

      outputs.total_count += author_ids.size + copyright_holder_ids.size

      Author.where(id: author_ids).delete_all unless author_ids.empty?
      CopyrightHolder.where(id: copyright_holder_ids).delete_all unless copyright_holder_ids.empty?
    end

    publishables.respond_to?(:touch_all) ? publishables.touch_all : publishables.each(&:touch)
  end
end
